//
//  WritingViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/29.
//

import UIKit
import PhotosUI

final class WritingViewController: BaseViewController {
    
    let selectInterestsLabel = {
        let view = UILabel()
        let attributedText = NSMutableAttributedString(string: "관심사 선택 ")
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "chevron.down")
        attachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 8)
        attributedText.append(NSAttributedString(attachment: attachment))
        view.attributedText = attributedText
        view.font = .systemFont(ofSize: 13, weight: .semibold)
        view.textColor = .black
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "제목을 입력하세요."
        return view
    }()
    
    let lineView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let contentTextView = {
        let view = UITextView()
        view.text = "내용을 입력하세요."
        view.font = .systemFont(ofSize: 16)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setBarButton()
        setToolber()
    }
    
    override func configure() {
        [selectInterestsLabel, titleTextField, lineView, contentTextView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        selectInterestsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(35)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(selectInterestsLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(1)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(titleTextField).inset(-4)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
        }
    }

}

extension WritingViewController {
    
    func setBarButton() {
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked))
        backBarButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func backButtonClicked() {
        //종료할거냐고 얼럿 띄우기
        dismiss(animated: true)
    }
    
    func setToolber() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let pictureButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(pictureButtonClicked))
        let hideKeyboardButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(hideKeyboardButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([pictureButton, flexibleSpace, hideKeyboardButton], animated: false)
        toolbar.barTintColor = .white
        toolbar.tintColor = .darkGray
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        contentTextView.inputAccessoryView = toolbar
    }
    
    @objc func pictureButtonClicked() {
        
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    @objc func hideKeyboardButtonClicked() {
        view.endEditing(true)
    }
}

extension WritingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
        
    }
}
