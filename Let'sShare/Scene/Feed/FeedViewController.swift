//
//  FeedViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/26.
//

import UIKit

final class FeedViewController: BaseViewController {
    
    let tableView = {
        let view = UITableView()
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        view.estimatedRowHeight = 90
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    var toTopBarButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.up")
        config.baseForegroundColor = .white
        config.imagePadding = 5
        view.configuration = config
        let barButton = UIBarButtonItem(customView: view)
        return barButton
    }()
    
    var searchBarButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "검색"
        config.image = UIImage(systemName: "magnifyingglass")
        config.baseForegroundColor = .white
        config.imagePadding = 5
        config.imagePlacement = .leading
        view.configuration = config
        let barButton = UIBarButtonItem(customView: view)
        return barButton
    }()
    
    let addBarButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "글쓰기"
        config.image = UIImage(systemName: "pencil.line")
        config.baseForegroundColor = .white
        config.imagePadding = 5
        config.imagePlacement = .leading
        view.configuration = config
        let barButton = UIBarButtonItem(customView: view)
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = .lightGray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.isToolbarHidden = false
        setToolbarButton()
    }
    
    func setToolbarButton() {
        navigationController?.toolbar.barTintColor = Color.Point.navy
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        var items = [UIBarButtonItem]()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let edgeSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        [edgeSpace, toTopBarButton, flexibleSpace, flexibleSpace, searchBarButton, flexibleSpace, flexibleSpace, addBarButton, flexibleSpace, edgeSpace].forEach { items.append($0) }
        self.toolbarItems = items
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
    
}
