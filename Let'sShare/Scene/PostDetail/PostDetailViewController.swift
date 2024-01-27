//
//  PostDetailViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2024/01/15.
//

import UIKit
import Kingfisher

final class PostDetailViewController: BaseViewController {
    
    let tableView = {
        let view = UITableView()
        view.register(PostDetailTableViewCell.self, forCellReuseIdentifier: PostDetailTableViewCell.identifier)
        view.rowHeight = 800
        view.separatorStyle = .none
        return view
    }()
    
    var postData: PostResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        view.backgroundColor = .pointYellow
        title = "상세화면"
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func configure() {
        [tableView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension PostDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewCell.identifier) as? PostDetailTableViewCell else { return UITableViewCell() }
        
        guard let postData else { return UITableViewCell() }
        
        cell.contentTextView.text = postData.content
        cell.titleLabel.text = postData.title
        
        let timeToDate = postData.time.toDate(to: .full) ?? Date()
        let timeToString = timeToDate.toString(of: .full)
        cell.userLabel.text = "\(postData.creator.nick)   \(timeToString)"
    
        DispatchQueue.main.async {
            self.addImagesToTextView(textView: cell.contentTextView)
        }
        
        return cell
        
    }
    
}

extension PostDetailViewController: UIGestureRecognizerDelegate {
    
    func addImagesToTextView(textView: UITextView) {
        
        guard let postData else { return }
        
        for imageString in postData.image {
            
            if let imageURL = URL(string: BaseURL.devURL + imageString) {
                print("=== imageURL : ", imageURL)
                KingfisherManager.shared.retrieveImage(with: imageURL) { [weak self] result in
                    switch result {
                    case .success(let value):
                        
                        self?.getImages(value.image, textView: textView)
                        
                    case .failure(let error):
                        print("== 이미지 다운 실패: \(error)")
                    }
                }
                
            } //if let imageURL
            
        } //for in
    }
    
    func setBackButton() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBarbuttonClicked))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem =  backButton
    }
    
    @objc private func backBarbuttonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
