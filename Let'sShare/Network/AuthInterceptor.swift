//
//  AuthInterceptor.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/28.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    
    static let shared = AuthInterceptor()
    
    private init() { }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var urlRequest = urlRequest
        let accessToken = UserDefaultsManager.access.myValue
        urlRequest.headers.add(.authorization(accessToken))
        
        print("===== urlRequest ====", urlRequest, urlRequest.headers)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print(#function)
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        print(#function)
        
        DispatchQueue.main.async {
            APIManager.shared.callRequest(type: AccessTokenResponse.self, api: .refresh, errorType: AccessTokenError.self) { response in
                switch response {
                case .success(let success):
                    print("== 재발급 성공 : ", success)
                    completion(.retry)
                case .failure(_):
                    print("== 실패")
                    completion(.doNotRetryWithError(error))
    //                if let common = failure as? CommonError {
    //                    print("=== retry 에러: ", common.errorDescription)
    //                } else if let error = failure as? AccessTokenError {
    //                    print("=== retry 에러: ", error.errorDescription)
    //                }
                }
            }
        }
        
        
    }
    
}
