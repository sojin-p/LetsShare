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
    
    let provider = MoyaProvider<UserAPI>(session: Moya.Session(interceptor: AuthInterceptor.shared))
    
    func callRequest<T: Decodable, U: RawRepresentable<Int>>(type: T.Type, api: UserAPI, errorType: U.Type, completion: @escaping (Result<T, Error>) -> Void ) {
        
        provider.request(api) { result in
            
            print("==APIManager==", result)
            
            switch result {
                
            case .success(let value):
                print("==success statusCode==", value.statusCode)
                do {
                    let success = try value.filter(statusCode: 200)
                    let result = try JSONDecoder().decode(type, from: success.data)
                    completion(.success(result))
                    
                } catch {
                    
                    let statusCode = value.statusCode
                    print("==catch statusCode==", statusCode)
                    if let common = CommonError(rawValue: statusCode) {
                        completion(.failure(common))
                    } else if let error = errorType.init(rawValue: statusCode) as? Error {
                        completion(.failure(error))
                    } else {
                        print("===구조체 담기 실패")
                    }
                
                }
            case .failure(let error): 
                print("===서버통신 error===", error)
            } //switch
        } //provider
        
    } //func callRequest
    
}
