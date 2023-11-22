//
//  APIModel.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/21.
//

import Foundation

//MARK: - 서버에 보내는 데이터
struct Join: Encodable {
    let email: String
    let password: String
    let nick: String
}

struct Login: Encodable {
    let email: String
    let password: String
}

struct ValidationEmail: Encodable {
    let email: String
}

//MARK: - 받는 데이터
struct JoinResponse: Decodable {
    let email: String
    let nick: String
}

struct ValidationEmailResponse: Decodable {
    let message: String
}
