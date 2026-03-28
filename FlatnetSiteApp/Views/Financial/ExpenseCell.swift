//
//  ExpenseCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation
import UIKit
import SnapKit

protocol ExpenseCellOutputDelegate: AnyObject {
    func invoiceButtonTapped(for invoiceUrl: String)
}

class ExpenseCell: UITableViewCell {
    
    static let identifier = "ExpenseCell"
    
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
        
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let invoiceButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Faturayı Görüntüle", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = UIColor.lightGray.cgColor
        
        return btn
    }()
    
    var invoiceURL: String = ""
    
    weak var outputDelegate: ExpenseCellOutputDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func layout() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(invoiceButton)
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.numberOfLines = 0
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        
        amountLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        amountLabel.textColor = .systemRed
        
        // SnapKit
        amountLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview()
            
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            
        }
        
        invoiceButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(30)
            make.width.equalTo(140)
            make.bottom.equalToSuperview().inset(8)
        }
        
        invoiceButton.addTarget(self, action: #selector(didTapInvoice), for: .touchUpInside)
        
    }
    
    @objc func didTapInvoice() {
        
        print("invoice url: \(self.invoiceURL)")
        self.outputDelegate?.invoiceButtonTapped(for: self.invoiceURL)
        
        
    }
    
    func configure(with model: Expense) {
        titleLabel.text = model.description
        dateLabel.text = model.date_display
        amountLabel.text = model.amount_display
        self.invoiceURL = model.invoice_url ?? ""
        
        if let invoice_url = model.invoice_url, !invoice_url.isEmpty {
            invoiceButton.isHidden = false
        }
        else {
            invoiceButton.isHidden = true
            
        }
        
    }
    
    
}
