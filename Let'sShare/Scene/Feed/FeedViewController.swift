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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func configure() {
        view.addSubview(tableView)
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
