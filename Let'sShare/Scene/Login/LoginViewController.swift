//
//  LoginViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/12.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    
    let iconImageView = {
        let view = UIImageView()
        view.image = Image.icon
        return view
    }()
    
    let containerView = WhiteAndShadowContainerView()
    
    let emailTextField = PointColorHoshiTextField(placeholder: "EMAIL", keyboardType: .emailAddress, isSecure: false)
    
    var emailResultLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .red
        return view
    }()
    
    let passwordTextField = PointColorHoshiTextField(placeholder: "PASSWORD", keyboardType: .default, isSecure: true)
    
    let passwordResultLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .red
        return view
    }()
    
    let loginButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "로그인"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Color.Point.navy
        config.cornerStyle = .capsule
        view.configuration = config
        return view
    }()
    
    let finePasswordLabel = {
        let view = UILabel()
        view.text = "아이디 / 비밀번호 찾기"
        view.textColor = Color.Point.navy
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.isUserInteractionEnabled = false
        view.textAlignment = .right
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.emailTextField.becomeFirstResponder()
        }
        
        bind()
        
    }
    
    func bind() {
        
        let input = LoginViewModel.Input(
            emailText: emailTextField.rx.text,
            passwordText: passwordTextField.rx.text)
        
        let output = viewModel.transform(input: input)
        
        output.emailErrorMessage
            .bind(to: emailResultLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordErrorMessage
            .bind(to: passwordResultLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.email
            .bind(with: self) { owner, bool in
                let color = bool ? Color.Point.yellow : UIColor.systemGray4
                owner.emailTextField.borderActiveColor = color
                owner.emailTextField.borderInactiveColor = color
                owner.emailResultLabel.isHidden = bool
            }
            .disposed(by: disposeBag)
        
        output.password
            .bind(with: self) { owner, bool in
                let color = bool ? Color.Point.yellow : UIColor.systemGray4
                owner.passwordTextField.borderActiveColor = color
                owner.passwordTextField.borderInactiveColor = color
                owner.passwordResultLabel.isHidden = bool
            }
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, bool in
                let color = bool ? Color.Point.navy : UIColor.systemGray4
                owner.loginButton.configuration?.baseBackgroundColor = color
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configure() {
        super.configure()
        
        [iconImageView, containerView, finePasswordLabel].forEach { view.addSubview($0) }
        [emailTextField, emailResultLabel, passwordTextField, passwordResultLabel, loginButton].forEach { containerView.addSubview($0) }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(containerView.snp.width).multipliedBy(0.8)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.bottom.equalTo(containerView.snp.top).offset(-35)
            make.centerX.equalTo(containerView)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }
        
        emailResultLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(emailTextField)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(emailTextField)
            make.height.equalTo(emailTextField)
        }
        
        passwordResultLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(passwordTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(emailTextField).inset(-3)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        finePasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(15)
            make.trailing.equalTo(containerView).offset(-5)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

