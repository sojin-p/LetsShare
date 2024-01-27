//
//  Toast+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2024/01/27.
//

import UIKit

enum Toast {
    case signUp
    case startActivity
    case hideActivity
    
    private var message: String {
        switch self {
        case .signUp:
            "회원가입 성공!"
        case .startActivity, .hideActivity:
            ""
        }
    }
    
    func makeToast(_ view: UIView?) {
        switch self {
        case .signUp:
            view?.makeToast(self.message, duration: 2.0, position: .top)
        case .startActivity:
            view?.makeToastActivity(.center)
        case .hideActivity:
            view?.hideToastActivity()
        }
    }
}
