//
//  LoginViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/12.
//

import UIKit
import TextFieldEffects

final class LoginViewController: BaseViewController {
    
    let iconImageView = {
        let view = UIImageView()
        view.image = Image.icon
        return view
    }()
    
    let containerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    let emailTextField = {
        let view = HoshiTextField(frame: .zero)
        view.placeholder = "EMAIL"
        view.placeholderColor = Color.Point.navy
        return view
    }()
    
    let emailResultLabel = {
        let view = UILabel()
        view.text = "이메일 형식(abc@de.fg)으로 입력해 주세요."
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .red
        return view
    }()
    
    let passwordTextField = {
        let view = HoshiTextField(frame: .zero)
        view.placeholder = "PASSWORD"
        view.placeholderColor = Color.Point.navy
        view.isSecureTextEntry = true
        return view
    }()
    
    let passwordResultLabel = {
        let view = UILabel()
        view.text = "이메일 형식(abc@de.fg)으로 입력해 주세요."
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

    override func viewDidLoad() {
        super.viewDidLoad()
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

