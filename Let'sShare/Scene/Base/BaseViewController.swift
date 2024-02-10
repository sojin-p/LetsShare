//
//  BaseViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/12.
//

import UIKit
import SnapKit
import Toast

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
    
    func showAlert(title: String, massage: String?) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func changeRootVC(_ vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate

        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func getImages(_ image: UIImage, textView: UITextView) {
        DispatchQueue.main.async {
            let width = textView.frame.width
            let resizedImage = self.resizeImage(image: image, targetWidth: width)
            self.photoIntoTextView(resizedImage, textView: textView)
        }
    }
    
    private func photoIntoTextView(_ image: UIImage, textView: UITextView) {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let imageString = NSAttributedString(attachment: attachment)
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        attributedText.append(imageString)
        
        textView.attributedText = attributedText
    }
    
    private func resizeImage(image: UIImage, targetWidth: CGFloat) -> UIImage {
        let originalSize = image.size
        let targetHeight = originalSize.height * targetWidth / originalSize.width
        
        let newSize = CGSize(width: targetWidth, height: targetHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    private var toastStyle = {
        var view = ToastStyle()
        view.backgroundColor = Color.Point.navy
        ToastManager.shared.style = view
        return view
    }()
    
    func setBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBarbuttonClicked))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem =  backButton
    }
    
    @objc private func backBarbuttonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
}
