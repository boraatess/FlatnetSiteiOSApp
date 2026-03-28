//
//  MydemandsHeader.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 1.10.2025.
//

import Foundation
import UIKit
import SnapKit

final class MydemandsHeader: UIView {
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "documentSearch")
        iv.tintColor = .black
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textColor = .black
        lbl.text = "Talep Detayı"
        return lbl
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Geri", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .black
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        
        return btn
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
    
    private let createdAtLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 10)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let updatedAtLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 10)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .right
        return lbl
    }()
    
    // yatay
    private let hStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        sv.distribution = .equalCentering
        return sv
    }()
    
    // yatay
    private let horizontalSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    // dikey
    private let vStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        return sv
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    private func setupUI() {
        
        backgroundColor = .white
        
        addSubview(statusLabel)
        
        addSubview(vStackView)
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
            make.height.equalTo(25)
        }
        
        let centerStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        centerStack.axis = .horizontal
        centerStack.spacing = 8
        centerStack.alignment = .center

        hStackView.addArrangedSubview(UIView())        // sol boşluk
        hStackView.addArrangedSubview(centerStack)     // ortadaki içerik
        hStackView.addArrangedSubview(UIView())        // sağ boşluk

        hStackView.distribution = .equalSpacing
        
        horizontalSV.addArrangedSubview(createdAtLabel)
        let spacer = UIView()
        horizontalSV.addArrangedSubview(spacer)
        // boş view
        horizontalSV.addArrangedSubview(updatedAtLabel)
        
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        vStackView.addArrangedSubview(spacer)
        vStackView.addArrangedSubview(horizontalSV)
        
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            
        }
        
    }
  
    func updateStatusColors(bgColor: UIColor, textColor: UIColor) {
        statusLabel.backgroundColor = bgColor
        statusLabel.textColor = textColor
    }
    
    // MARK: - Configure
    func configure(status: String, statusColor: UIColor,
                   createdAt: String, updatedAt: String) {
        statusLabel.text = status
        createdAtLabel.text = "Oluşturulma:\n\(createdAt)"
        updatedAtLabel.text = "Güncellenme:\n\(updatedAt)"
        
        
    }
    
    
}
