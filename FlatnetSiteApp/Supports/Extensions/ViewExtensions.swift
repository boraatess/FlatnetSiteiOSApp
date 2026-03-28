//
//  ViewExtensions.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation
import UIKit


extension UIView {
    func setGradientBackground(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // Eğer eski gradient layer varsa temizle
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}


extension UITableView {
    func addDefaultRefresh(target: Any, action: Selector) {
        let refresh = UIRefreshControl()
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .blue
        activity.startAnimating()
        activity.center = CGPoint(x: refresh.bounds.midX, y: refresh.bounds.midY)
        refresh.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refresh
    }
    
    func stopRefreshing() {
          self.refreshControl?.endRefreshing()
      }
    
}


extension UIImageView {
    func load(from url: URL, placeholder: UIImage? = nil) {
        // İlk başta placeholder göster
        self.image = placeholder
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

extension UIViewController {
    
    /// Generic alert helper
    /// - Parameters:
    ///   - title: Alert başlığı
    ///   - message: Alert mesajı
    ///   - actions: (title, style, handler) tuple array
    func presentAlert(
        title: String?,
        message: String?,
        actions: [(title: String, style: UIAlertAction.Style, handler: (() -> Void)?)]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            }
            alert.addAction(alertAction)
        }
        
        present(alert, animated: true)
    }
    
    func resetFields(_ fields: [UIView]) {
        fields.forEach { field in
            switch field {
            case let textField as UITextField:
                textField.text = ""
            case let textView as UITextView:
                textView.text = ""
            case let switchControl as UISwitch:
                switchControl.isOn = false
            case let segmented as UISegmentedControl:
                segmented.selectedSegmentIndex = UISegmentedControl.noSegment
            default:
                break
            }
        }
    }
    
    // Gradient katmanı oluşturup bir UIView'a ekleyen bir fonksiyon
    func applyBlueLifeGradient(to view: UIView, startColor: UIColor, endColor: UIColor) {
        // 1. CAGradientLayer oluşturun
        let gradientLayer = CAGradientLayer()
        
        // 2. Renkleri belirleyin (CGColor türünde olmalılar)
        // Görüntüdeki renklere yakın tahmini değerler:
        let startColor = UIColor(red: 0.12, green: 0.44, blue: 0.48, alpha: 1.0).cgColor // Koyu yeşilimsi turkuaz
        let endColor = UIColor(red: 0.20, green: 0.59, blue: 0.86, alpha: 1.0).cgColor   // Daha parlak mavi
        
        gradientLayer.colors = [startColor, endColor]
        
        // 3. Başlangıç ve bitiş noktalarını belirleyin (normalized coordinates: 0,0 - 1,1)
        // Sol üst (0,0) -> Sağ alt (1,1) geçişi için:
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Sol üst
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)   // Sağ alt
        
        // 4. Gradient katmanının çerçevesini (frame) ayarlayın
        // UIView'ın tüm alanını kaplaması için view'ın bounds'unu kullanın
        gradientLayer.frame = view.bounds
        
        // 5. Gradient katmanını view'ın layer'ına alt katman (sublayer) olarak ekleyin
        // En alta eklenmeli ki, diğer UI elemanları (label, ikon vb.) üstünde kalsın
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // **Önemli Not:** Eğer view'ın boyutu sonradan değişirse (örneğin layoutSubviews çağrıldığında),
        // gradientLayer.frame'i de güncellemeniz gerekecektir.
        
    }

    
    
}

final class ContentSizedTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

final class ContentSizedCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
