//
//  CraftsmenTableviewCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation
import UIKit
import SnapKit


protocol CraftsmenCellOutputDelegate: AnyObject {
    func callButtonClicked(with craftsmanID: Int)
}

class CraftsmenTableviewCell: UITableViewCell {

    static let identifier = "CraftsmenTableviewCell"

    weak var outputdelegate: CraftsmenCellOutputDelegate?
    var craftsMenID: Int = 0

    private let categoryIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "paintbrush")
        iv.tintColor = .gray
        return iv
    }()

    private let jobNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 10)
        return lbl
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()

    private let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .gray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let infoPhoneLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .gray
        lbl.numberOfLines = 0
        lbl.text = "Numaranın üzerine basarak arayabilirsiniz."
        return lbl
    }()
    
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    // UIButton ile icon solda, text sağda
    private let actionButton: UIButton = {
        let btn = UIButton(type: .system)
      
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.attributedTitle = AttributedString( "Talep Oluştur ve Ara", attributes: AttributeContainer([.font: UIFont.boldSystemFont(ofSize: 12)]))
            
            btn.setImage(UIImage(systemName: "phone.arrow.up.right"), for: .normal)
            config.imagePadding = 4          // icon ve text arası boşluk
            config.imagePlacement = .leading // icon solda, text sağda
            config.baseForegroundColor = .white
            config.background.backgroundColor = AppColors.shared.butonIndıgoColor
            
            btn.configuration = config
        } else {
            // iOS 14 ve altı için eski yöntem
            btn.setTitle("Talep Oluştur ve Ara", for: .normal)
            btn.backgroundColor = AppColors.shared.butonIndıgoColor
            btn.setImage(UIImage(systemName: "phone.arrow.up.right"), for: .normal)
            btn.tintColor = .white
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }

        return btn
    }()

    private let phoneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.isHidden = true
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "phone.fill")
            config.imagePadding = 4          // icon ve text arası boşluk
            config.imagePlacement = .leading // icon solda, text sağda
            config.baseForegroundColor = .systemGreen
            config.background.backgroundColor = .white
            btn.configuration = config
        } else {
            // iOS 14 ve altı için eski yöntem
            btn.setImage(UIImage(systemName: "phone.fill"), for: .normal)
            btn.tintColor = .systemGreen
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }
        
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = false
        setupUI()

        actionButton.addTarget(self, action: #selector(showPhone), for: .touchUpInside)
        phoneButton.addTarget(self, action: #selector(callNumber), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func showPhone() {
        outputdelegate?.callButtonClicked(with: craftsMenID)

        guard let phoneTitle = phoneButton.title(for: .normal) else { return }

        actionButton.isHidden = true
        phoneButton.isHidden = false
        phoneButton.setTitle(phoneTitle, for: .normal)
    }

    @objc private func callNumber() {
        guard let number = phoneButton.title(for: .normal) else { return }
        print("Calling \(number)")
        Utils.shared.call(number: number)
    }

    func configureCell(with craftsMen: CraftsmenData) {
        nameLabel.text = craftsMen.fullName
        infoLabel.text = craftsMen.notes
        jobNameLabel.text = craftsMen.specialty
        craftsMenID = craftsMen.id

        if craftsMen.phoneNumber.isEmpty {
            actionButton.isHidden = false
            phoneButton.isHidden = true
        } else {
            actionButton.isHidden = true
            phoneButton.isHidden = false
            phoneButton.setTitle(craftsMen.phoneNumber, for: .normal)
        }
    }

    private func setupUI() {
        contentView.backgroundColor = AppColors.shared.vcBgColor
        contentView.addSubview(containerView)

        [categoryIcon, jobNameLabel, nameLabel, actionButton,
         infoPhoneLabel, seperator, phoneButton, infoLabel].forEach {
            containerView.addSubview($0)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        categoryIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }

        jobNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(categoryIcon.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.height.equalTo(10)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(jobNameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(36)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }

        actionButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(40)
        }

        phoneButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(40)
        }
        
        infoPhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.actionButton.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            
        }
        
        seperator.snp.makeConstraints { make in
            make.top.equalTo(self.actionButton.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(4)
            make.height.equalTo(1)
        }

        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
