//
//  PostDetailTableViewCell.swift
//  Let'sShare
//
//  Created by 박소진 on 2024/01/16.
//

import UIKit

final class PostDetailTableViewCell: BaseTableViewCell {
    
    let titleLabel = {
        let view = UILabel()
        view.text = "타이틀입니다"
        view.font = .systemFont(ofSize: 18, weight: .regular)
        return view
    }()
    
    let userLabel = {
        let view = UILabel()
        view.text = "닉네임 2024.01.01"
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .systemGray2
        return view
    }()
    
    private let lineView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    let contentTextView = {
        let view = UITextView()
        view.text = "내용입니다."
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.isEditable = false
        return view
    }()
    
    override func configure() {
        [titleLabel, userLabel, lineView, contentTextView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            
        }
        
        userLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(titleLabel)
            make.height.equalTo(1)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(19)
            make.trailing.equalTo(titleLabel)
            make.leading.equalTo(titleLabel).offset(-4)
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
}
