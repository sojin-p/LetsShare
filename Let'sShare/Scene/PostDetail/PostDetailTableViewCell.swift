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
        return view
    }()
    
    let userLabel = {
        let view = UILabel()
        view.text = "닉네임 2024.01.01"
        return view
    }()
    
    private let lineView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let contentTextView = {
        let view = UITextView()
        view.text = "내용입니다."
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
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(titleLabel)
            make.height.equalTo(1)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
}
