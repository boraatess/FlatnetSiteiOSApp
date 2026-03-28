//
//  HomeTableviewCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 10.09.2025.
//

import UIKit
import SnapKit


class HomeTableviewCell: UITableViewCell {
    
    static let identifier = "HomeTableviewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
        
    }()
    
    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.numberOfLines = .zero
        label.textColor = .black
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = .zero
        label.textColor = .black
        return label
    }()
    
    private let describeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = .zero
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    func configureViews(with data: Announcement) {
        dateLabel.text = data.createdAt.formattedDate()
        titleLabel.text = data.title
        describeLabel.text = data.content
    }
    
    private func configureLayout() {

        contentView.backgroundColor = .clear
             
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
        }
        
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview()
            
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview()
            
        }
        
        containerView.addSubview(seperator)
        seperator.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(4)
            make.height.equalTo(1)
        }
        
        containerView.addSubview(describeLabel)
        describeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.seperator.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
        
        
        
    }
    
}
