//
//  PostModel.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/30.
//

import Foundation

struct Post: Encodable {
    let title: String
    let content: String
    let imageData: [Data]
    let product_id: String
}

//받는 데이터
struct PostResponse: Decodable {
    let _id: String
    let creator: Creator
    let time: String
    let title: String
    let content: String
    let product_id: String
}

struct Creator: Decodable {
    let _id: String
    let nick: String
}
