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
    case refresh
    case createPost(data: Post)
}

extension UserAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: BaseURL.authURL) else {
            fatalError("Invalid BaseURL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .join: return "join"
        case .login: return "login"
        case .validationEmail: return "validation/email"
        case .refresh: return "refresh"
        case .createPost: return "post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join, .validationEmail, .login, .createPost: 
            return .post
        case .refresh: 
            return .get
        }
    }
    
    var task: Moya.Task { //파라미터 영역
        switch self {
        case .join(let data):
            return .requestJSONEncodable(data)
        case .validationEmail(let data):
            return .requestJSONEncodable(data)
        case .login(let data):
            return .requestJSONEncodable(data)
        case .refresh:
            return .requestPlain
        case .createPost(let data):
            return .uploadMultipart(setMultipartData(data))
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json",
         "SesacKey": APIKey.sesac]
    }
}

extension UserAPI {
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    func setMultipartData(_ data: Post) -> [MultipartFormData] {
        let productIDData = MultipartFormData(
            provider: .data(data.product_id.data(using: .utf8)!),
            name: "product_id")
        let titleData = MultipartFormData(
            provider: .data(data.title.data(using: .utf8)!),
            name: "title")
        let contentData = MultipartFormData(
            provider: .data(data.content.data(using: .utf8)!),
            name: "content")
        let multipartData: [MultipartFormData] = [productIDData, titleData, contentData]
        return multipartData
    }
    
}
