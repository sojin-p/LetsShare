//
//  NetworkError+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/21.
//

import Foundation

//공통 에러
enum NetworkError: Int, Error {
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
