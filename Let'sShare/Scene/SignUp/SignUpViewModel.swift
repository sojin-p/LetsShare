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
                APIManager.shared.callRequest(type: ValidationEmailResponse.self, api: .validationEmail(data: data), errorType: UserError.self) { response in
                    switch response {
                    case .success(let success):
                        print("==== 메세지: ", success)
                        isAvailable.onNext(true)
                        //사용 가능 얼럿
                        
                    case .failure(let failure):
                        if let common = failure as? CommonError {
                            print("=== 에러: ", common.errorDescription)
                        } else if let error = failure as? UserError {
                            print("=== 에러: ", error.errorDescription)
                        }
                        isAvailable.onNext(false)
                        //사용 불가 얼럿
                    }
                }
            }
            .disposed(by: disposeBag)
        
        let validation = Observable.combineLatest(nickname, password, checkPassword, isAvailable, email) { nickname, password, checkPassword, isAvailable, email in
            print("====: ", nickname, isAvailable, password, checkPassword, email)
            return nickname && password && checkPassword && isAvailable && email
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
