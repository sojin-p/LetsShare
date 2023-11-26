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
        let emailCheckTapped: ControlEvent<Void>
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
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let isAvailable = BehaviorSubject(value: false)
        
        let nickname = loginVM.checkValidation(input: input.nicknameText, valid: .invalidNickname, errorMessage: LoginValidationError.invalidNickname.errorMessage, label: nicknameErrorMessage)
        
        let email = loginVM.checkValidation(input: input.emailText, valid: .invalidEmail, errorMessage: LoginValidationError.invalidEmail.errorMessage, label: emailErrorMessage)
        
        let password = loginVM.checkValidation(input: input.passwordText, valid: .invalidPassword, errorMessage: LoginValidationError.invalidPassword.errorMessage, label: passwordErrorMessage)
        
        let checkPassword = Observable.combineLatest(input.passwordText.orEmpty, input.passwordCheckText.orEmpty) { password, checkPassword in
            if password.isEmpty {
                return false
            }
            return password == checkPassword
        }
        
        input.emailCheckTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText.orEmpty)
            .debug()
            .subscribe(with: self) { owner, email in
                let data = ValidationEmail(email: email)
                APIManager.shared.callRequest(type: ValidationEmailResponse.self, api: .validationEmail(data: data)) { response in
                    switch response {
                    case .success(let success):
                        print("==== 메세지: ", success.message)
                        //토스트 띄우기
                        isAvailable.onNext(true)
                    case .failure(let failure):
                        
                        isAvailable.onNext(false)
                        print("=== 에러: ", failure.errorDescription)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        let validation = Observable.combineLatest(nickname, password, checkPassword, isAvailable) { nickname, password, checkPassword, isAvailable in
            return nickname && password && checkPassword && isAvailable
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
