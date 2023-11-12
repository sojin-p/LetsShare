//
//  BaseViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/12.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() {
        view.backgroundColor = Color.Background.basic
    }
    
    func setConstraints() { }
}
