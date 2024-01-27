//
//  SignUpViewConroller.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/18.
//

import UIKit
import RxSwift
import TextFieldEffects

final class SignUpViewConroller: BaseViewController, UIGestureRecognizerDelegate {
    
    let requiredContainerView = WhiteAndShadowContainerView()
    
    let nicknameTextField = PointColorHoshiTextField(placeholder: "NICKNAME", keyboardType: .default, isSecure: false)
    
    let emailTextField = PointColorHoshiTextField(placeholder: "EMAIL", keyboardType: .emailAddress, isSecure: false)
    
    let emailDuplicationCheckButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "확인"
        config.buttonSize = .mini
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Color.Point.navy
        config.cornerStyle = .capsule
        view.configuration = config
        return view
    }()
    
    let passwordTextField = PointColorHoshiTextField(placeholder: "PASSWORD", keyboardType: .default, isSecure: true)
    
    let passwordCheckTextField = PointColorHoshiTextField(placeholder: "CONFIRM PASSWORD", keyboardType: .default, isSecure: true)
    
    let signUpButton = {
        let view = UIButton()
        view.backgroundColor = Color.Point.navy
        view.setTitle("회원가입", for: .normal)
        view.tintColor = .white
        return view
    }()
    
    let bottomView = {
        let view = UIView()
        view.backgroundColor = Color.Point.navy
        return view
    }()
    
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        DispatchQueue.main.async {
            self.nicknameTextField.becomeFirstResponder()
        }
        
        bind()
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
    }
    
    func bind() {
        
        let input = SignUpViewModel.Input(
            nicknameText: nicknameTextField.rx.text,
            emailText: emailTextField.rx.text,
            passwordText: passwordTextField.rx.text, 
            passwordCheckText: passwordCheckTextField.rx.text, 
            emailCheckTapped: emailDuplicationCheckButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        bindBorderColor(output.nickname, textField: nicknameTextField)
        bindBorderColor(output.email, textField: emailTextField)
        bindBorderColor(output.password, textField: passwordTextField)
        bindBorderColor(output.checkPassword, textField: passwordCheckTextField)
        
        output.email
            .bind(to: emailDuplicationCheckButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, bool in
                let color = bool ? Color.Point.navy : UIColor.systemGray4
                owner.signUpButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func signUpButtonClicked() {
        let data = Join(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", nick: nicknameTextField.text ?? "")
        APIManager.shared.callRequest(type: JoinResponse.self, api: .join(data: data), errorType: UserError.self) { response in
            switch response {
            case .success(let success):
                print("==== 메세지: ", success)
                //화면 전환
            case .failure(let failure):
                if let common = failure as? CommonError {
                    print("=== 에러: ", common.errorDescription)
                } else if let error = failure as? UserError {
                    print("=== 에러: ", error.errorDescription)
                }
                //얼럿
            }
        }
    }
    
    func bindBorderColor(_ outputBool: Observable<Bool>, textField: HoshiTextField) {
        outputBool
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, bool in
                let color = bool ? Color.Point.yellow : UIColor.systemGray4
                textField.borderActiveColor = color
                textField.borderInactiveColor = color
            }
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        super.configure()
        
        [requiredContainerView, signUpButton, bottomView].forEach { view.addSubview($0) }
        
        [nicknameTextField, emailTextField, emailDuplicationCheckButton, passwordTextField, passwordCheckTextField].forEach { requiredContainerView.addSubview($0) }
        
    }
    
    override func setConstraints() {
        
        requiredContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.41)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            make.leading.height.equalTo(nicknameTextField)
            make.trailing.equalTo(emailDuplicationCheckButton.snp.leading).offset(-8)
        }
        
        emailDuplicationCheckButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField)
            make.height.equalTo(35)
            make.width.equalTo(55)
            make.trailing.equalTo(nicknameTextField)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.horizontalEdges.height.equalTo(nicknameTextField)
        }
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.horizontalEdges.height.equalTo(nicknameTextField)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(55)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
