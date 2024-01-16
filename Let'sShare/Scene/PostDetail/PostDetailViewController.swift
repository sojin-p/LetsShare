//
//  PostDetailViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2024/01/15.
//

import UIKit

final class PostDetailViewController: BaseViewController {
    
    let tableView = {
        let view = UITableView()
        view.register(PostDetailTableViewCell.self, forCellReuseIdentifier: PostDetailTableViewCell.identifier)
        view.rowHeight = 200
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pointYellow
        title = "상세화면"
        tableView.dataSource = self
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
        
        return cell
        
    }
    
}
