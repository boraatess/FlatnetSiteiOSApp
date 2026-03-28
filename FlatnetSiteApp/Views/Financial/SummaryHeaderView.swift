//
//  SummaryHeaderView.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation
import UIKit
import SnapKit

class SummaryHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "SummaryHeaderView"
    
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        layout()
     
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func layout() {
        
        
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        
        amountLabel.font = .boldSystemFont(ofSize: 16)
        amountLabel.textColor = .white
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func configure(title: String, totalAmount: String, isIncome: Bool) {
        titleLabel.text = title
        amountLabel.text = totalAmount
        
        let incomeColor = AppColors.shared.incomeColor
        let expenseColor = AppColors.shared.expenseColor
        
        contentView.backgroundColor = isIncome ? incomeColor : expenseColor
        
        
    }
    
}
