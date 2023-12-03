//
//  ValidationError+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/18.
//

import Foundation

enum LoginValidationError: Error {
    case emptyString
    case invalidEmail
    case invalidPassword
    case invalidNickname
    
    var errorMessage: String {
        switch self {
        case .emptyString: return "내용을 입력해주세요."
        case .invalidEmail: return "이메일 형식(abc@de.fg)으로 입력해 주세요."
        case .invalidPassword: return "영문, 숫자, 특수문자 포함한 6~30자"
        case .invalidNickname: return "한글 or 영문 2~6자"
        }
    }
    
    var regex: String {
        switch self {
        case .emptyString:
            return ""
        case .invalidEmail:
            return "^([0-9a-z._-])+@[A-Za-z0-9.-]+.[A-Za-z]{2,20}$"
        case .invalidPassword:
            return "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{6,30}$"
        case .invalidNickname:
            return "^[a-zA-Z0-9ㄱ-ㅎ가-힣]{2,6}$"
        }
    }
    
}
