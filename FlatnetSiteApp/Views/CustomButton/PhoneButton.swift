//
//  PhoneButton.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 30.09.2025.
//

import Foundation
import UIKit
import SnapKit


class PhoneButton: UIButton {
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    private let iconView = UIImageView()
    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 12)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 6
        clipsToBounds = true
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        
        addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        vStack.addArrangedSubview(iconView)
        vStack.addArrangedSubview(titleLbl)
    }
    
    func configure(title: String, titleTextcolor: UIColor,
                   image: UIImage?, bgColor: UIColor) {
        titleLbl.text = title
        titleLbl.textColor = titleTextcolor
        iconView.image = image
        iconView.tintColor = titleTextcolor
        backgroundColor = bgColor
    }
    
    // hit test button üzerine gelsin
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.contains(point)
    }
}
