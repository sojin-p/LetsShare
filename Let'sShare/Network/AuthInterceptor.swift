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
        
        print(#function, "== adapt 헤더 끼워넣기!!")
        
        var urlRequest = urlRequest
        let accessToken = UserDefaultsManager.access.myValue
        let refreshToken = UserDefaultsManager.refresh.myValue
        
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(refreshToken, forHTTPHeaderField: "Refresh")
        
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print(#function)
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            print("===리트라이 가드문 419가 아닐때")
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("====리트라이 액세스 토큰 갱신 필요!!")
        
        DispatchQueue.main.async {
            APIManager.shared.callRequest(type: AccessTokenResponse.self, api: .refresh, errorType: AccessTokenError.self) { response in
                switch response {
                case .success(let success):
                    print("== 재발급 성공 : ", success)
                    UserDefaultsManager.access.myValue = success.token
                    completion(.retry)
                case .failure(let error):
                    print("== 재발급 실패, 재로그인 필요")
                    completion(.doNotRetryWithError(error))
                }
            }
        }
        
        
    }
    
}
