//
//  RadioButton.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 4.10.2025.
//

import Foundation
import UIKit

class CustomRadioButton: UIButton {
    
    // seçili/boş renkler
    var selectedBorderColor: UIColor = .systemBlue
    var unselectedBorderColor: UIColor = .lightGray
    var selectedFillColor: UIColor = UIColor.systemBlue.withAlphaComponent(0.1)
    var unselectedFillColor: UIColor = .clear
    
    private let circleLayer = CAShapeLayer()
    private let innerCircleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override var isSelected: Bool {
        didSet {
            updateState()
        }
        
    }
      
    private func setupView() {
        self.backgroundColor = .clear
        self.addTarget(self, action: #selector(toggleSelected), for: .touchUpInside)
        
        // dış çember
        circleLayer.strokeColor = unselectedBorderColor.cgColor
        circleLayer.fillColor = unselectedFillColor.cgColor
        circleLayer.lineWidth = 2
        layer.addSublayer(circleLayer)
        
        // iç dolu çember
        innerCircleLayer.fillColor = selectedBorderColor.cgColor
        innerCircleLayer.isHidden = true
        layer.addSublayer(innerCircleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = min(bounds.width, bounds.height) / 2
        let circlePath = UIBezierPath(ovalIn: bounds)
        circleLayer.path = circlePath.cgPath
        
        let inset: CGFloat = bounds.width * 0.35 // iç çember daha küçük
        let innerPath = UIBezierPath(ovalIn: bounds.insetBy(dx: inset, dy: inset))
        innerCircleLayer.path = innerPath.cgPath
    }
    
    @objc private func toggleSelected() {
        isSelected.toggle()
        updateState()
    }
    
    private func updateState() {
        if isSelected {
            circleLayer.strokeColor = selectedBorderColor.cgColor
            circleLayer.fillColor = selectedFillColor.cgColor
            innerCircleLayer.isHidden = false
        } else {
            circleLayer.strokeColor = unselectedBorderColor.cgColor
            circleLayer.fillColor = unselectedFillColor.cgColor
            innerCircleLayer.isHidden = true
        }
    }
}
