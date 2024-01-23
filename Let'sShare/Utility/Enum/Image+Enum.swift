//
//  Image+Enum.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/12.
//

import UIKit

enum Image {
    static let icon = UIImage(resource: .icon)
    static let backIcon = UIImage(resource: .backIcon)
    static let sidebarIcon = UIImage(resource: .sidebarIcon).withRenderingMode(.alwaysOriginal)
    static let addIcon = UIImage(resource: .addIcon).withRenderingMode(.alwaysTemplate)
}
