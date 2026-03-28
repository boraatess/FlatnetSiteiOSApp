//
//  DocumentsTableviewCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 29.09.2025.
//

import Foundation
import UIKit
import SnapKit


class DocumentsTableviewCell: UITableViewCell {
    
    static let identifier = "DocumentsTableviewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let createdAtLaBabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    func configure(with doc: Documents) {
        titleLabel.text = doc.docType
        let createdAtString = doc.uploadDate ?? ""
        createdAtLaBabel.text = createdAtString.formattedDate()
        
    }
    
    
    private func setupLayout() {
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
        
        
        addSubview(createdAtLaBabel)
        
        createdAtLaBabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(8)
            make.height.equalTo(20)
            make.width.equalTo(200)

        }
        
    }
    
}
