//
//  API+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/21.
//

import Foundation
import Moya

enum UserAPI {
    case join(data: Join)
    case validationEmail(data: ValidationEmail)
    case login(data: Login)
}

extension UserAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: BaseURL.devURL) else {
            fatalError("Invalid BaseURL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .join: return "join"
        case .login: return "login"
        case .validationEmail: return "validation/email"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task { //파라미터 영역
        switch self {
        case .join(let data):
            return .requestJSONEncodable(data)
        case .validationEmail(let data):
            return .requestJSONEncodable(data)
        case .login(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type" : "application/json",
         "SesacKey" : APIKey.sesac]
    }
}
