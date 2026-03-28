//
//  RulesHeaderView.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 11.10.2025.
//

import Foundation
import UIKit
import SnapKit

protocol RulesHeaderViewDelegate: AnyObject {
    func headerTapped(section: Int)
}

class RulesHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "RulesHeaderView"
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "doc.text")
        iv.tintColor = .black
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let arrowIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.down")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 8
        return v
    }()
    
    weak var delegate: RulesHeaderViewDelegate?
    private var sectionIndex: Int = 0
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, section: Int, isExpanded: Bool) {
        titleLabel.text = title
        sectionIndex = section
        
        // Duruma göre ok yönünü değiştir
        UIView.animate(withDuration: 0.25) {
            self.arrowIcon.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrowIcon)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
            make.height.equalTo(44)
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        arrowIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    @objc private func headerTapped() {
        delegate?.headerTapped(section: sectionIndex)
    }
    
    
}
