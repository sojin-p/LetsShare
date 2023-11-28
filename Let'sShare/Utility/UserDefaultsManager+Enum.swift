//
//  UserDefaultsManager+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/28.
//

import Foundation

enum UserDefaultsManager {
    
    struct LetsShareDefaults<T> {
        let key: String
        let defaultValue: T
        
        var myValue: T {
            get {
                UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            }
            set {
                UserDefaults.standard.setValue(newValue, forKey: key)
            }
        }
    }
    
    enum Key: String {
        case access
        case refresh
    }
    
    static var access = LetsShareDefaults(key: Key.access.rawValue, defaultValue: "엑세스 토큰 없음")
    
    static var refresh = LetsShareDefaults(key: Key.refresh.rawValue, defaultValue: "리프레시 토큰 없음")
    
}
