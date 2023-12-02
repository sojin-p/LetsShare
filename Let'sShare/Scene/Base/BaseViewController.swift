//
//  BaseViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/12.
//

import UIKit
import SnapKit

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
    
    func changeRootVC(_ vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate

        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
