//
//  ReusableView+Protocol.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/28.
//

import UIKit

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusableViewProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableViewProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UICollectionReusableView: ReusableViewProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
