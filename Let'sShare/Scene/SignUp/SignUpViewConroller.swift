//
//  SignUpViewConroller.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/18.
//

import UIKit

final class SignUpViewConroller: BaseViewController {
    
    let requiredContainerView = WhiteAndShadowContainerView()
    
    let nickNameTextField = PointColorHoshiTextField(placeholder: "NICKNAME", keyboardType: .default, isSecure: false)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.nickNameTextField.becomeFirstResponder()
        }
        
    }
    
    override func configure() {
        super.configure()
        
        [requiredContainerView, signUpButton, bottomView].forEach { view.addSubview($0) }
        
        [nickNameTextField, emailTextField, emailDuplicationCheckButton, passwordTextField, passwordCheckTextField].forEach { requiredContainerView.addSubview($0) }
        
    }
    
    override func setConstraints() {
        
        requiredContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.41)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(16)
            make.leading.height.equalTo(nickNameTextField)
            make.trailing.equalTo(emailDuplicationCheckButton.snp.leading).offset(-8)
        }
        
        emailDuplicationCheckButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField)
            make.height.equalTo(35)
            make.width.equalTo(55)
            make.trailing.equalTo(nickNameTextField)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.horizontalEdges.height.equalTo(nickNameTextField)
        }
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.horizontalEdges.height.equalTo(nickNameTextField)
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
