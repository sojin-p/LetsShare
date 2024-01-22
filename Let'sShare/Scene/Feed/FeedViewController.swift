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
    
    var refreshBarButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "새로고침"
//        config.image = UIImage(systemName: "arrow.clockwise")
        config.baseForegroundColor = .white
        config.imagePadding = 5
        view.configuration = config
        let barButton = UIBarButtonItem(customView: view)
        return barButton
    }()
    
    var searchBarButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "검색하기"
//        config.image = UIImage(systemName: "magnifyingglass")
        config.baseForegroundColor = .white
        config.imagePadding = 5
        config.imagePlacement = .leading
        view.configuration = config
        let barButton = UIBarButtonItem(customView: view)
        return barButton
    }()
    
    lazy var addBarButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width / 3, height: 0))
        var config = UIButton.Configuration.plain()
        config.title = "글쓰기"
//        config.image = UIImage(systemName: "pencil.line")
        config.baseForegroundColor = .white
        config.imagePadding = 5
        config.imagePlacement = .leading
        view.configuration = config
        view.addTarget(self, action: #selector(addBarButtonClicked), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: view)
        return barButton
    }()
    
    let backAlphaView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.isHidden = true
        return view
    }()
    
    var postData = PostDataResponse(data: [], next_cursor: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setToolbarButton()
        requestPost()
        
        let menuBarButton = UIBarButtonItem(title: nil, image: UIImage(resource: .sidebarIcon), target: self, action: #selector(menuBarButtonClicked))
        navigationItem.leftBarButtonItem = menuBarButton
        
    }
    
    func requestPost() {
        APIManager.shared.callRequest(type: PostDataResponse.self, api: .Post(next: "", limit: "", productId: "letsShare_sojin_id"), errorType: AccessTokenError.self) { [weak self] response in
            
            switch response {
            case .success(let success):
//                print("==== 메세지: ", success)
                self?.postData.data.append(contentsOf: success.data)
                print("========= 포스트 :", self?.postData)
                self?.tableView.reloadData()
                
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
        present(nav, animated: true)
    }
    
    override func configure() {
        [tableView, backAlphaView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
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
        
        let timeToDate = post.time.toDate(to: .full) ?? Date()
        let timeToString = timeToDate.toString(of: .full)
        
        cell.subTitleLabel.text = "\(post.creator.nick)   \(timeToString)"
        
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(UserDefaultsManager.access.myValue, forHTTPHeaderField: "Authorization")
            requestBody.setValue(APIKey.sesac, forHTTPHeaderField: "SesacKey")
            return requestBody
        }
        
        if let firstImage = post.image.first, let url = URL(string: BaseURL.devURL + firstImage) {
            let options: KingfisherOptionsInfo = [.requestModifier(imageDownloadRequest)]
            cell.thumbImageView.kf.setImage(with: url, options: options)
            print("=====", url)
        } else{
            print("=== url 오류 or image nil")
            cell.thumbImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("===didselect")
        let vc = PostDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FeedViewController {
    
    func setToolbarButton() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = Color.Point.navy
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        var items = [UIBarButtonItem]()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let edgeSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        [edgeSpace, refreshBarButton, flexibleSpace, addBarButton, flexibleSpace, searchBarButton, edgeSpace].forEach { items.append($0) }
        self.toolbarItems = items
    }
    
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
