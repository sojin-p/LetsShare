//
//  APIManager.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/20.
//

import Foundation
import Moya

final class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    let provider = MoyaProvider<UserAPI>()
    
    func callRequest<T: Decodable>(type: T.Type, api: UserAPI, completion: @escaping (Result<T, NetworkError>) -> Void ) {
        
        provider.request(api) { result in
            switch result {
            case .success(let value):
                do {
                    let success = try value.filter(statusCode: 200)
                    let result = try JSONDecoder().decode(type, from: success.data)
                    completion(.success(result))
                    
                } catch {
                    
                    switch value.statusCode {
                    case 201...419:
                        if let error = UserError(rawValue: value.statusCode) {
                            let error = NetworkError.user(error)
                            completion(.failure(error))
                        }
                    case 420...444, 446...500:
                        if let commonError = CommonError(rawValue: value.statusCode) {
                            let error = NetworkError.common(commonError)
                            completion(.failure(error))
                        }
                    case 445:
                        print("권한에러")
                    default:
                        print("===구조체 담기 실패ㅠㅠ")
                    }
                }
            case .failure(let error): 
                print("===서버통신 error===", error)
            } //switch
        } //provider
        
    } //func callRequest
    
}
