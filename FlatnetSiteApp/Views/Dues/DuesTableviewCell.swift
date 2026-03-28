//
//  DuesTableviewCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 17.09.2025.
//

import UIKit
import SnapKit
import FirebaseCrashlytics

protocol DuesTableviewCellDelegate: AnyObject {
    func didTaponReceiptButton()
    func sendReceiptClicked(with period: String, and totalPrice: String, _ duesId: Int)
}

class DuesTableviewCell: UITableViewCell {
    
    static let identifier = "DuesTableviewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let periodTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let periodValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let dueDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Son Ödeme Tarihi"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let dueDateValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let statusLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.backgroundColor = .systemYellow
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let amountTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let amountValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let receiptButton: ReceiptButton = {
        let button = ReceiptButton()
        
        return button
    }()
    
    weak var delegate: DuesTableviewCellDelegate?
    
    private var periodValue: String = ""
    private var totalPriceValue: String = ""
    private var duesID: Int = 0
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = AppColors.shared.vcBgColor
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        setupLayout()
        receiptButton.addTarget(self, action: #selector(receiptButtonTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func receiptButtonTapped() {
        
        delegate?.didTaponReceiptButton()
        delegate?.sendReceiptClicked(with: self.periodValue, and: self.totalPriceValue, self.duesID)
        
    }
    
    func cellConfigure(with due: DuesList) {
        periodTitleLabel.text = "Dönem"
        periodValueLabel.text = due.period
        
        if due.status == "Ödendi" {
            statusLabel.text = due.status
            statusLabel.textColor = .white
            statusLabel.backgroundColor = AppColors.shared.successColor
            receiptButton.alpha = 0.5
            receiptButton.isUserInteractionEnabled = false
            
        }
        else {
            statusLabel.text = due.status
            statusLabel.textColor = .black
            statusLabel.backgroundColor = AppColors.shared.warningColor
            receiptButton.alpha = 1.0
            receiptButton.isUserInteractionEnabled = true
            
            
        }
        
        dueDateValueLabel.text = due.dueDate
        amountTitleLabel.text = "Tutar"
        amountValueLabel.text = due.amountDisplay
        self.periodValue = due.period
        self.totalPriceValue = due.amountDisplay
        self.duesID = due.id
        receiptButton.configure(title: "Makbuz Gönder", image:  UIImage(systemName: "square.and.arrow.up"))
        
    }

    func cellConfigureMydemands(with requestArray: RequestArray) {
        dueDateTitleLabel.isHidden = true
        dueDateValueLabel.isHidden = true
        receiptButton.configure(title: "Detay Göster", image:  UIImage(systemName: ""))
        periodTitleLabel.text = "Konu"
        amountTitleLabel.text = "Oluşturulma tarihi"
        let createdAtString = requestArray.createdAt ?? ""
        amountValueLabel.text = createdAtString.formattedDate()
        periodValueLabel.text = requestArray.title
        statusLabel.text = requestArray.status
        
    }
    
    private func setupLayout() {
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            
        }
        
        containerView.addSubview(periodTitleLabel)
        containerView.addSubview(periodValueLabel)
        containerView.addSubview(dueDateTitleLabel)
        containerView.addSubview(dueDateValueLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(amountTitleLabel)
        containerView.addSubview(amountValueLabel)
        containerView.addSubview(receiptButton)
        
        periodTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
        
        periodValueLabel.snp.makeConstraints { make in
            make.top.equalTo(periodTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(periodTitleLabel)
        }
        
        dueDateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(periodValueLabel.snp.bottom).offset(8)
            make.leading.equalTo(periodTitleLabel)
        }
        
        dueDateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(dueDateTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(dueDateTitleLabel)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(60)
        }
        
        amountTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(dueDateTitleLabel)
        }
        
        amountValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(amountTitleLabel)
            make.top.equalTo(amountTitleLabel.snp.bottom).offset(4)
        }
        
        receiptButton.snp.makeConstraints { make in
            make.top.equalTo(dueDateValueLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().inset(6)
        }
    }
}
