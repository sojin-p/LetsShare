//
//  Interests+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2024/01/25.
//

import Foundation

enum Interests: String, CaseIterable {
    
    case all = "ALL"
    case free = "자유게시판"
    case food = "맛집/요리"
    case trip = "여행"
    case exercise = "운동/스포츠"
    case culture = "문화/예술"
    case education = "IT/교육"
    case society = "사회/정치"
    case movie = "영화/드라마"
    case nature = "자연/환경"
    
    var productID: String {
        switch self {
        case .all: "letsShare_sojin_id"
        case .free, .food, .trip, .exercise, .culture, .education, .society, .movie, .nature: "letsShare_sojin_\(self)"
        }
    }
    
}
