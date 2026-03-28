//
//  ReceiptButton.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 29.09.2025.
//

import Foundation
import UIKit

class ReceiptButton: UIButton {
    
    private let iconView = UIImageView()
    private let titleLbl = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
       
        setTitleColor(.white, for: .normal)
        backgroundColor = AppColors.shared.butonIndıgoColor
        tintColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
        
        // icon
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        
        // title
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        titleLbl.font = .systemFont(ofSize: 16, weight: .medium)
        
        addSubview(iconView)
        addSubview(titleLbl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 12
        let iconSize: CGFloat = 20
        
        // Icon solda sabit
        iconView.frame = CGRect(x: padding,
                                y: (bounds.height - iconSize) / 2,
                                width: iconSize,
                                height: iconSize)
        
        // Title ortada
        titleLbl.frame = CGRect(x: 0,
                                y: 0,
                                width: bounds.width,
                                height: bounds.height)
    }
    
    // Dışarıdan image + text set edilebilsin
    func configure(title: String, image: UIImage?) {
        titleLbl.text = title
        iconView.image = image
    }
}
