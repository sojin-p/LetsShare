//
//  LoginViewModel.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/18.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    struct Input {
        let emailText: ControlProperty<String?>
        let passwordText: ControlProperty<String?>
    }
    
    struct Output {
        let emailErrorMessage: PublishRelay<String>
        let passwordErrorMessage: PublishRelay<String>
        let email: Observable<Bool>
        let password: Observable<Bool>
        let validation: Observable<Bool>
    }
    
    let emailErrorMessage = PublishRelay<String>()
    let passwordErrorMessage = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        let email = checkValidation(input: input.emailText, valid: .invalidEmail, errorMessage: LoginValidationError.invalidEmail.errorMessage, label: emailErrorMessage)
        
        let password = checkValidation(input: input.passwordText, valid: .invalidPassword, errorMessage: LoginValidationError.invalidPassword.errorMessage, label: passwordErrorMessage)
        
        let validation = Observable.combineLatest(email, password) { email, password in
            return email && password
        }
        
        return Output(
            emailErrorMessage: emailErrorMessage,
            passwordErrorMessage: passwordErrorMessage,
            email: email,
            password: password,
            validation: validation)
        
    }
    
    func checkValidation(input: ControlProperty<String?>, valid: LoginValidationError, errorMessage: String, label: PublishRelay<String>) -> Observable<Bool> {
        let result = input.orEmpty
            .map { text in
                do {
                    let result = try self.checkLoginValidation(text: text, valid: valid)
                    return result
                } catch {
                    if text.count > 1 {
                        label.accept(errorMessage)
                    }
                    return false
                }
            }
        return result
    }
    
    func checkLoginValidation(text: String, valid: LoginValidationError) throws -> Bool {
        let isValid = text.range(of: valid.regex, options: .regularExpression) != nil
        if isValid {
            return true
        } else {
            throw valid
        }
    }
    
}
