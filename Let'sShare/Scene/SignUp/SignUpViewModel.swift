//
//  SignUpViewModel.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/20.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let emailText: ControlProperty<String?>
        let passwordText: ControlProperty<String?>
        let passwordCheckText: ControlProperty<String?>
    }
    
    struct Output {
        let nicknameErrorMessage: PublishRelay<String>
        let emailErrorMessage: PublishRelay<String>
        let passwordErrorMessage: PublishRelay<String>
        let nickname: Observable<Bool>
        let email: Observable<Bool>
        let password: Observable<Bool>
        let checkPassword: Observable<Bool>
        let validation: Observable<Bool>
    }
    
    let loginVM = LoginViewModel()
    
    private let nicknameErrorMessage = PublishRelay<String>()
    private let emailErrorMessage = PublishRelay<String>()
    private let passwordErrorMessage = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        let nickname = loginVM.checkValidation(input: input.nicknameText, valid: .invalidNickname, errorMessage: LoginValidationError.invalidNickname.errorMessage, label: nicknameErrorMessage)
        
        let email = loginVM.checkValidation(input: input.emailText, valid: .invalidEmail, errorMessage: LoginValidationError.invalidEmail.errorMessage, label: emailErrorMessage)
        
        let password = loginVM.checkValidation(input: input.passwordText, valid: .invalidPassword, errorMessage: LoginValidationError.invalidPassword.errorMessage, label: passwordErrorMessage)
        
        let checkPassword = Observable.combineLatest(input.passwordText.orEmpty, input.passwordCheckText.orEmpty) { password, checkPassword in
            if password.isEmpty {
                return false
            }
            return password == checkPassword
        }
        
        let validation = Observable.combineLatest(nickname, email, password, checkPassword) { nickname, email, password, checkPassword in
            return nickname && email && password && checkPassword
        }
        
        return Output(
            nicknameErrorMessage: nicknameErrorMessage,
            emailErrorMessage: emailErrorMessage,
            passwordErrorMessage: passwordErrorMessage,
            nickname: nickname,
            email: email,
            password: password, 
            checkPassword: checkPassword,
            validation: validation)
    }
}
