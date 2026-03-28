//
//  SplashViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 11.09.2025.
//

import Foundation
import UIKit
import SnapKit


class SplashViewController: UIViewController {
    
    let viewModel = SplashViewModel()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "FlatnetSite"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private let logoSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Apartman Yönetim Sistemi"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var logoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoLabel, logoSubLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.outputdelegate = self
        viewModel.checkUser()
        setupLayout()
                
    }
  
    private func configureViewModel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.viewModel.checkUser()
        })
    }
    
}

extension SplashViewController: SplashViewModelOutputDelegate {
    
    func showSuccessPushnotify(with token: String) {
        
        DispatchQueue.main.async {
            Utils.shared.showAutoDismissAlert(title: "Başarılı!", message: "Fcm token: \(token)", duration: 3.0, viewController: self)
        }
        
    }
    
    func appStartWithLogin() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func appStartWithTabbar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let vc = TabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        })
       
    }
}

extension SplashViewController {
    
    func setupLayout() {
        
        view.backgroundColor = AppColors.shared.bgColor
        
        print("splash vc...")
        
        view.addSubview(logoStack)
           
           logoStack.snp.makeConstraints { make in
               make.center.equalToSuperview()   // ✅ ekranın ortasına
           }
        
        
    }
    
    
}
