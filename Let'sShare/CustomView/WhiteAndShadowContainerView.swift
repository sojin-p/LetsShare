//
//  WhiteAndShadowContainerView.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/19.
//

import UIKit

final class WhiteAndShadowContainerView: BaseView {
    
    override func configure() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
    }

}
