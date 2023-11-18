//
//  WelcomeViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/19.
//

import UIKit

final class WelcomeViewController: BaseViewController {
    
    let backImageView = {
        let view = UIImageView()
        view.image = Image.backIcon
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let backView = {
        let view = UIView()
//        view.backgroundColor = .green
        return view
    }()
    
    let containerView = {
        let view = UIView()
//        view.backgroundColor = .systemYellow
        return view
    }()
    
    let appNameLabel = {
        let view = UILabel()
        view.text = "Let's Share!"
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 26, weight: .light)
        view.textColor = Color.Point.navy
        return view
    }()
    
    let iconImageView = {
        let view = UIImageView()
        view.image = Image.icon
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let buttonContainerView = {
        let view = UIView()
//        view.backgroundColor = .systemMint
        return view
    }()
    
    let loginButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "회원가입"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Color.Point.navy
        config.cornerStyle = .capsule
        view.configuration = config
        return view
    }()
    
    let signUpButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "로그인"
        config.baseForegroundColor = Color.Point.navy
        config.baseBackgroundColor = .white
        config.cornerStyle = .capsule
        view.configuration = config
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        
        [backImageView, backView].forEach { view.addSubview($0) }
        [containerView, buttonContainerView].forEach { backView.addSubview($0) }
        [appNameLabel, iconImageView].forEach { containerView.addSubview($0) }
        [loginButton, signUpButton].forEach { buttonContainerView.addSubview($0) }
        
    }
    
    override func setConstraints() {
        backImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        backView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.4)
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        buttonContainerView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(buttonContainerView).multipliedBy(0.45)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(buttonContainerView).multipliedBy(0.45)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
    
}
