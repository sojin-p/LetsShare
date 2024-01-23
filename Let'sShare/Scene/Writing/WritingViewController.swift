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
    
    let doneButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "등록"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Color.Point.navy
        config.cornerStyle = .capsule
        config.buttonSize = .mini
        view.configuration = config
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setBarButton()
        setToolber()
        
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        selectInterestsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectInterestsLabelClicked)))
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
    
    @objc func selectInterestsLabelClicked() {
        print("selectInterestsLabelClicked")
        let vc = InterestsViewController()
        present(vc, animated: true)
    }
    
    @objc func backButtonClicked() {
        //종료할거냐고 얼럿 띄우기
        dismiss(animated: true)
    }
    
    @objc func doneButtonClicked() {
        
        let images = getImagesFromTextView(contentTextView)
        
        print("===", titleTextField.text ?? "제목입니다", contentTextView.text ?? "본문입니다", "== 이미지 : ", images)
        
        let data = Post(
            title: titleTextField.text ?? "제목 비어있음",
            content: contentTextView.text ?? "본문입니다",
            imageData: images,
            product_id: "letsShare_sojin_id")
        
        APIManager.shared.callRequest(type: PostResponse.self, api: .createPost(data: data), errorType: AccessTokenError.self) { [weak self] response in
            switch response {
            case .success(let success):
                print("==== 메세지: ", success)
                //메인 게시글로 화면 전환
                
            case .failure(let failure):
                if let common = failure as? CommonError {
                    print("=== CommonError: ", common.errorDescription)
                } else if let error = failure as? AccessTokenError {
                    print("=== AccessTokenError: ", error.errorDescription)
                    if error.rawValue == 419 {
                        self?.changeRootVC(LoginViewController())
                    }
                }
            }
        }
        
    }
    
    func setBarButton() {
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked))
        backBarButton.tintColor = .black
        
        let doneBarButton = UIBarButtonItem(customView: doneButton)
        
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = doneBarButton
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
        config.selectionLimit = 5
        
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
        
        picker.dismiss(animated: true)
        
        for result in results {
            
            let itemProvider = result.itemProvider
            
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.webP.identifier) {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.webP.identifier) { [weak self] data, error in
                    
                    guard let self = self else { return }
                    if let data = data, let image = UIImage(data: data) {
                        getImages(image, textView: self.contentTextView)
                    }
                    
                }
                
            } else if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    
                    guard let self = self else { return }
                    guard let image = image as? UIImage else {
                        print("Image nil")
                        return
                    }
                    getImages(image, textView: self.contentTextView)
                    
                }
                
            } else {
                print("이미지 가져오기 실패")
            }
        }
        
    }
    
    func getImagesFromTextView(_ textView: UITextView) -> [Data] {
        
        var imageData: [Data] = []
        
        if let attributedText = textView.attributedText {
            attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: attributedText.length), options: []) { value, range, _ in
                
                if let attachment = value as? NSTextAttachment {
                    if let image = attachment.image {
                        imageData.append(imageToData(image))
                    }
                }
                
            }
        }
        
        return imageData
        
    }
    
    func imageToData(_ image: UIImage) -> Data {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return Data() }
        return imageData
    }
    
}
