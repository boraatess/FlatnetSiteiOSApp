//
//  IncomeCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation
import UIKit
import SnapKit

class IncomeCell: UITableViewCell {
    
    static let identifier = "IncomeCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
      
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func layout() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        titleLabel.font = .systemFont(ofSize: 14)
        
        amountLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        amountLabel.textColor = .systemGreen
        
        // SnapKit
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(self.amountLabel.snp.leading).inset(16)
            make.centerY.equalToSuperview()
            
        }
      
        
    }
    
    
    func configure(with model: Income) {
        titleLabel.text = model.description
        amountLabel.text = model.amount_display
        
        
    }
    
    
}
