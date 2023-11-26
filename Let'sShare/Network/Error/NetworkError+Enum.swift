//
//  NetworkError+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/21.
//

import Foundation

enum NetworkError: Error {
    case common(_ common: CommonError)
    case user(_ signUp: UserError)

    var errorDescription: String {
        switch self {
        case .common(let commonError):
            return commonError.errorDescription
        case .user(let userError):
            return userError.errorDescription
        }
    }
}

//공통 에러
enum CommonError: Int, Error {
    case unathorized = 420
    case unavailable = 429 //과호출
    case invalidURL = 444 //비정상 url
    case invalidServer = 500 //서버에러
    
    var errorDescription: String {
        switch self {
        case .unathorized:
            return "인증 정보가 없습니다."
        case .unavailable:
            return "서버에 접속할 수 없습니다."
        case .invalidURL:
            return "유효하지 않은 주소입니다."
        case .invalidServer:
            return "서버 점검 중입니다."
        }
    }
}

enum UserError: Int, Error {
    
    case empty = 400 //필수값 누락
    case unavailable = 409 //중복
    case checkEmail = 401 //미가입 or 비밀번호 불일치
    
    var errorDescription: String {
        switch self {
        case .empty:
            return "필수 항목을 입력해 주세요."
        case .unavailable:
            return "이미 가입된 이메일입니다."
        case .checkEmail:
            return "이메일 또는 비밀번호가 일치하지 않습니다."
        }
    }
}
