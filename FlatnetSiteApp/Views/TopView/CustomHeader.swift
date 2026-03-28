//
//  CustomHeader.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 17.09.2025.
//

import Foundation
import UIKit
import SnapKit

final class CustomHeader: UIView {
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = .white
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let hStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 6
        return sv
    }()
    
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
        
        backgroundColor = AppColors.shared.bgColor

        addSubview(stackView)
        
        hStackView.addArrangedSubview(iconImageView)
        hStackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(hStackView)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(25) // ikon boyutu
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
    
}


final class HeaderView: UIView {
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .black
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let hStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 6
        return sv
    }()
    
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
    
    func configureIcon(_ color: UIColor) {
        iconImageView.tintColor = color
    }
    
    // MARK: - Setup
    private func setupUI() {
                
        backgroundColor = .white
        
        addSubview(stackView)
        
        hStackView.addArrangedSubview(iconImageView)
        hStackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(hStackView)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(25) // ikon boyutu
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
}
