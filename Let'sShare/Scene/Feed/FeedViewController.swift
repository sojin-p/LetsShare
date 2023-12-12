//
//  FeedViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/26.
//

import UIKit
import SideMenu

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = .lightGray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setToolbarButton()
        
        let menuBarButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "star"), target: self, action: #selector(menuBarButtonClicked))
        navigationItem.leftBarButtonItem = menuBarButton
    }
    
    @objc func menuBarButtonClicked() {
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
        [tableView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
        
        return cell
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
        let menu = SideMenuNavigationController(rootViewController: InterestsViewController())
        menu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        menu.presentationStyle = .menuSlideIn
        return menu
    }
    
}
