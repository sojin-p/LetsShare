//
//  FeedTableViewCell.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/28.
//

import UIKit

final class FeedTableViewCell: BaseTableViewCell {
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 12
        return view
    }()
    
    let thumbImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
//        view.isHidden = true
        return view
    }()
    
    private let labelStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 4
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "타이틀입니다타이틀입니다타이틀입니다타이틀입니다타이틀입니다"
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = 2
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.text = "닉네임  2023.11.29 21:11"
        view.font = .systemFont(ofSize: 13)
        view.textColor = .lightGray
        return view
    }()
    
    let commentslabel = {
        let view = UILabel()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.text = "12"
        view.font = .systemFont(ofSize: 13)
        view.textAlignment = .center
//        view.isHidden = true
        return view
    }()
    
    override func configure() {
        [stackView].forEach { contentView.addSubview($0) }
        [thumbImageView, labelStackView, commentslabel].forEach { stackView.addArrangedSubview($0) }
        [titleLabel, subTitleLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        commentslabel.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalToSuperview()
        }
    }
    
}

