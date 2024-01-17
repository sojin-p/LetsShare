//
//  DareFormatType+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2024/01/17.
//

import UIKit

enum DateFormatType {
    case full
    case withoutTime
    case justTime
    
    var description: String {
        switch self {
        case .full: "yyyy.MM.dd HH:mm"
        case .withoutTime: "yyyy.MM.dd"
        case .justTime: "HH:mm"
        }
    }
}

extension Date {
    
    func toString(of type: DateFormatType) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = type.description
        return formatter.string(from: self)
    }
    
}

extension String {
    
    func toDate(to type: DateFormatType) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = type.description
        return formatter.date(from: self)
    }
    
}
