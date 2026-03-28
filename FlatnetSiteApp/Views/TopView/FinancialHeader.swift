//
//  FinancialHeader.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 30.09.2025.
//

import Foundation
import UIKit
import SnapKit

final class FinancialHeader: UIView {
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 12)
        lbl.textColor = .black
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 14)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let totalAmountIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "swapVertical")
        iv.tintColor = .black
        
        return iv
    }()
    
    private let totalAmountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 14)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    // yatay
    private let hStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 6
        return sv
    }()
    
    // yatay
    private let horizontalSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 6
        return sv
    }()
    
    // dikey
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 6
        return sv
    }()
    
    // MARK: - Init
    init(icon: UIImage?, title: String, subtitle: String) {
        super.init(frame: .zero)
        setupUI()
        configure(icon: icon, title: title, subtitle: subtitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
        
    }
    
    // MARK: - Setup
    private func setupUI() {
        
        backgroundColor = .white
        
        addSubview(stackView)
        
        // üst başlık satırı
        hStackView.addArrangedSubview(iconImageView)
        hStackView.addArrangedSubview(titleLabel)
        
        // toplam satırı
        horizontalSV.addArrangedSubview(totalAmountIV)
        horizontalSV.addArrangedSubview(totalAmountLabel)
        
        // ana dikey stack içine ekle
        stackView.addArrangedSubview(hStackView)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(horizontalSV)   // <-- yeni satır burası
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(25)
            // ikon boyutu
        }
        
        totalAmountIV.snp.makeConstraints { make in
            make.size.equalTo(20)
            // toplam ikon boyutu
        }
        
    }
    
    func setLabelsAttributedText(with title: String, and desc: NSAttributedString) {
        titleLabel.text = title
        subtitleLabel.attributedText = desc
    }
    
    // MARK: - Configure
    func configure(icon: UIImage?, title: String, subtitle: String) {
        iconImageView.image = icon
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    func setSubtitletext(with subtitle: String) {
        subtitleLabel.text = subtitle
    }
    
    func setTotalAmounttext(with totalAmount: String) {
        totalAmountLabel.text = totalAmount
    }
    
}
