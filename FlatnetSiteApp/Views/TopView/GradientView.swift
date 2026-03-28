//
//  GradientView.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 14.10.2025.
//

import UIKit
import Foundation

class GradientView: UIView {
    // Katman türünü CAGradientLayer olarak belirtiyoruz
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // Kolay erişim için layer'ı gradientLayer olarak cast ediyoruz
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        let startColor = UIColor(red: 0.12, green: 0.44, blue: 0.48, alpha: 1.0).cgColor
        let endColor = UIColor(red: 0.20, green: 0.59, blue: 0.86, alpha: 1.0).cgColor
        
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // Bu yöntemde, layerClass override edildiği için frame'i güncellemeye GEREK KALMAZ.
        // View'ın boyutu değiştikçe layer otomatik olarak kendini ayarlar.
    }
}

// Kullanım:
// let containerView = GradientView()
