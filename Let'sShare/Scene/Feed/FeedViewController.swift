//
//  FeedViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/26.
//

import UIKit
import SideMenu
import Kingfisher

final class FeedViewController: BaseViewController {
    
    let tableView = {
        let view = UITableView()
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        view.estimatedRowHeight = 90
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    let addPostButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 0))
        let image = Image.addIcon
        DispatchQueue.main.async {
            view.setImage(image, for: .normal)
            view.setImage(image, for: [.normal, .highlighted])
            view.tintColor = .white
            view.backgroundColor = Color.Point.navy
            view.layer.cornerRadius = view.frame.width / 2
        }
        return view
    }()
    
    let backAlphaView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.isHidden = true
        return view
    }()
    
    var postData = PostDataResponse(data: [], next_cursor: "")
    
    var nextCursur = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "자유게시판"
        
        requestPost()
        
        addPostButton.addTarget(self, action: #selector(addBarButtonClicked), for: .touchUpInside)
        
        let menuBarButton = UIBarButtonItem(title: nil, image: Image.sidebarIcon, target: self, action: #selector(menuBarButtonClicked))
        navigationItem.leftBarButtonItem = menuBarButton
        
    }
    
    func requestPost() {
        
        Toast.startActivity.makeToast(self.view)
        
        APIManager.shared.callRequest(type: PostDataResponse.self, api: .Post(next: nextCursur, limit: "20", productId: "letsShare_sojin_id"), errorType: AccessTokenError.self) { [weak self] response in
            
            switch response {
            case .success(let success):
//                print("==== 메세지: ", success)
                self?.postData.data.append(contentsOf: success.data)
                self?.nextCursur = success.next_cursor
                self?.tableView.reloadData()
                Toast.hideActivity.makeToast(self?.view)
                
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
    
    @objc func menuBarButtonClicked() {
        backAlphaView.isHidden = false
        present(setSideMenu(), animated: true)
        print("=====menuBarButtonClicked")
    }
    
    @objc func addBarButtonClicked() {
        let vc = WritingViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        vc.completion = { [weak self] in
            print("등록 완료!")
            self?.postData = PostDataResponse(data: [], next_cursor: "")
            self?.requestPost()
        }
        
        present(nav, animated: true)
    }
    
    override func configure() {
        [tableView, backAlphaView, addPostButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        addPostButton.snp.makeConstraints { make in
            make.size.equalTo(65)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(35)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backAlphaView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
        
        let post = postData.data[indexPath.row]
        
        cell.titleLabel.text = post.title
        
        let timeToDate = post.time.toDate(to: .serverDateISO8601) ?? Date()
        let timeToString = timeToDate.toString(of: .full)
        
        cell.subTitleLabel.text = "\(post.creator.nick)   \(timeToString)"
        
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(UserDefaultsManager.access.myValue, forHTTPHeaderField: "Authorization")
            requestBody.setValue(APIKey.sesac, forHTTPHeaderField: "SesacKey")
            return requestBody
        }
        
        let retryStrategy = DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(3))
        
        if let firstImage = post.image.first, let url = URL(string: BaseURL.devURL + firstImage) {
            let options: KingfisherOptionsInfo = [
                .requestModifier(imageDownloadRequest),
                .transition(.fade(1.2))//,
//                .retryStrategy(retryStrategy)
            ]
            cell.thumbImageView.kf.indicatorType = .activity
            cell.thumbImageView.kf.setImage(with: url, options: options)
            print("=====", url)
        } else {
            print("=== url 오류 or image nil")
            cell.thumbImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let vc = PostDetailViewController()
        vc.postData = postData.data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                if nextCursur != "0" {
                    requestPost()
                } else {
                    view.makeToast("더 이상 게시글이 없습니다.", duration: 1.2, position: .bottom)
                }
            }
    }
    
}

extension FeedViewController {
    
    func setSideMenu() -> SideMenuNavigationController {
        let vc = InterestsViewController()
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        menu.presentationStyle = .menuSlideIn
        
        vc.completion = { [weak self] in
            self?.backAlphaView.isHidden = true
        }
        
        return menu
    }
    
}
