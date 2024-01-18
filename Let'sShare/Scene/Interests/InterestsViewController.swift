//
//  InterestsViewController.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/12/04.
//

import UIKit

final class InterestsViewController: BaseViewController {
    
    let tableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.separatorStyle = .none
        view.rowHeight = 50
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "관심사 선택"
        view.font = .systemFont(ofSize: 17, weight: .bold)
        return view
    }()

    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSheet()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completion?()
    }
    
    override func configure() {
        [titleLabel, tableView].forEach { view.addSubview($0) }
    }

    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension InterestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "여행"
        
        return cell
    }
    
}

extension InterestsViewController {
    
    func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.detents = [.medium(), .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 20
                sheet.prefersGrabberVisible = true
            }
        }
        
    }
    
}
