//
//  MenuViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 11.09.2025.
//

import Foundation
import UIKit
import SnapKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelectMenuItem(_ item: MenuItem)
}

enum MenuItem: String, CaseIterable {
    case profil = "Profil"
    case belgeYukle = "Belge Yükle"
    case ustaRehberi = "Usta Rehberi"
    case kasaDurumu = "Kasa Durumu"
    case yeniTalep = "Yeni Talep"
    case siteKurallari = "Site Kuralları"
    case oturumKapat = "Oturumu Kapat"
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.separatorStyle = .none
        
        return tableview
    }()
    
    private let headerView: GradientView = {
        let view = GradientView()
        // view.backgroundColor = AppColors.shared.bgColor
        
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Blue Life-1\nYönetim Sistemine hoş geldiniz."
        label.numberOfLines = 0
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // Header
        view.addSubview(headerView)
            
       // headerView.backgroundColor = AppColors.shared.bgColor
        
        let colors = [AppColors.shared.gradientFirstColor, AppColors.shared.gradientSecondColor ]
        
            
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(200)
            
        }
        
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
        // headerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // headerView.setGradientBackground(colors: colors)

            // Logo
        /*
        headerView.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "appLogo") // senin ikon
        logoImageView.contentMode = .scaleAspectFit
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(6)
            make.width.height.equalTo(40)
        }
            */
        
        // Welcome
        headerView.addSubview(nameLabel)
        headerView.addSubview(welcomeLabel)
        
        welcomeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(nameLabel.snp.top).inset(-10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            
        }
        
        // Title
        welcomeLabel.text = "Blue Life-1\nYönetim Sistemine hoş geldiniz."
      
        // TableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        guard let userProfile = AuthManager.shared.currentUser else { return }
        
        nameLabel.text = "Merhaba, \(userProfile.name)"
        
    }
    
    
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = MenuItem.allCases[indexPath.row]
        cell.textLabel?.text = item.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        cell.imageView?.image = UIImage(systemName: iconName(for: item))
        cell.textLabel?.textColor = .black
        cell.imageView?.tintColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = MenuItem.allCases[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didSelectMenuItem(item)
        }
        
        
    }
    
    private func iconName(for item: MenuItem) -> String {
        switch item {
        case .profil: return "person.circle"
        case .belgeYukle: return "square.and.arrow.up"
        case .ustaRehberi: return "book"
        case .kasaDurumu: return "dollarsign.circle"
        case .yeniTalep: return "plus.circle"
        case .siteKurallari: return "list.bullet"
        case .oturumKapat: return "power"
        }
    }
    
}
