//
//  MyDemandsCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 1.10.2025.
//

import Foundation
import UIKit
import SnapKit

protocol MydemandsCellDelegate: AnyObject {
    func didTaponDetailButton(with request: RequestArray)
}

class MyDemandsCell: UITableViewCell {
    
    static let identifier = "MyDemandsCell"
/*        contentView.layer.cornerRadius = 8
 contentView.layer.shadowColor = UIColor.black.cgColor
 contentView.layer.shadowOpacity = 0.1
 contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
 contentView.layer.shadowRadius = 4
 */
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let periodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Konu:"
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
        label.text = "Oluşturulma Tarihi:"
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .black
        
        return label
    }()
    
    private let dueDateValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
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
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Detay Göster", for: .normal)
        button.backgroundColor = AppColors.shared.butonIndıgoColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()
    
    private var requestArray: RequestArray?
    
    weak var outputDelegate: MydemandsCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func detailButtonTapped() {
        if let array = self.requestArray {
            outputDelegate?.didTaponDetailButton(with: array)
            
        }
        
    }
    
    func cellConfigureMydemands(with requestArray: RequestArray) {
        self.requestArray = requestArray
        let createdAtString = requestArray.createdAt ?? ""
        dueDateValueLabel.text = createdAtString.formattedDate()
        periodValueLabel.text = requestArray.title
        
        statusLabel.text = requestArray.status
        
        if let status = requestArray.statusDisplay {
            
            statusLabel.text = status.text

            switch status.color {
                
            case "success":
                let statusColor = AppColors.shared.successColor
                statusLabel.backgroundColor = statusColor
                statusLabel.textColor = .white
                
            case "info":
                let statusColor = AppColors.shared.warningColor
                statusLabel.backgroundColor = statusColor
                statusLabel.textColor = .black
                
            default :
                break
                
            }
            
            
        }
        
    }
    
    func setupUI() {
        
        contentView.backgroundColor = AppColors.shared.vcBgColor
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
        }
        
        containerView.addSubview(periodTitleLabel)
        containerView.addSubview(periodValueLabel)
        containerView.addSubview(dueDateTitleLabel)
        containerView.addSubview(dueDateValueLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(detailButton)
        
        periodTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
        
        periodValueLabel.snp.makeConstraints { make in
            make.top.equalTo(periodTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(periodTitleLabel)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(60)
        }
        
        dueDateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        dueDateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(dueDateTitleLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(8)
            
        }
        
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(dueDateValueLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(8)
            
        }
        
        
    }
    
    
}
