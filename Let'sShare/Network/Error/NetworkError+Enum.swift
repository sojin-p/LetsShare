//
//  NetworkError+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/21.
//

import Foundation

enum NetworkError: Error {
    case common(_ common: CommonError)
    case user(_ user: UserError)
    case refresh(_ token: AccessTokenError)

    var errorDescription: String {
        switch self {
        case .common(let commonError):
            return commonError.errorDescription
        case .user(let userError):
            return userError.errorDescription
        case .refresh(let token):
            return token.errorDescription
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

//회원가입, 로그인, 이메일 중복체크
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

//토큰
enum AccessTokenError: Int, Error {
    case invalidRequest = 400 //잘못된 요청
    case unavailable = 401 //유효하지 않은 액세스 토큰
    case forbidden = 403 //접근 권한이 없습니다.
    case available = 409 //액세스 토큰 살아있음
    case notFound = 410 //게시글을 찾을 수 없습니다.
    case expiredRefreshToken = 418 //리프레시 만료 재로그인
    case expiredToken = 419 //액세스 만료
    case unauthorised = 445 //게시글 접근 불가(작성자 아님)
    
    var errorDescription: String {
        switch self {
        case .unavailable:
            return "유효하지 않은 정보입니다."
        case .forbidden, .unauthorised:
            return "접근 권한이 없습니다."
        case .available:
            return "액세스 토큰이 만료되지 않았습니다."
        case .expiredRefreshToken:
            return "로그인 기한이 만료되었습니다. 다시 로그인해 주세요."
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .expiredToken:
            return "액세스 토큰이 만료되었습니다."
        case .notFound:
            return "게시글을 찾을 수 없습니다."
        }
    }
}
