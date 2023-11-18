//
//  PointColorHoshiTextField.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/18.
//

import UIKit
import TextFieldEffects

final class PointColorHoshiTextField: HoshiTextField {
    
    init(placeholder: String, keyboardType: UIKeyboardType, isSecure: Bool) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        isSecureTextEntry = isSecure
        placeholderColor = Color.Point.navy
        borderActiveColor = UIColor.systemGray4
        borderInactiveColor = UIColor.systemGray4
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
