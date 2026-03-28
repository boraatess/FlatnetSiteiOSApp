//
//  BaseVC.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import Foundation
import UIKit
import SideMenu
import SnapKit
import SVProgressHUD

class BaseVC<ViewModel>: UIViewController where ViewModel: ViewModelProtocol {
    
    var viewModel: ViewModel

    private var menu: SideMenuNavigationController?

    let navBar = UIView()
    private let titleLabel = UILabel()
    private let menuButton = UIButton(type: .system)
    
    
    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.outputDelegate = self as? ViewModel.T
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationController?.navigationBar.isHidden = true
        
        setupNavBar()
        // setupCustomNavBar()
        setupMenu()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
        
        /*
        if AuthManager.shared.isLoggedIn {
            self.navBar.isHidden = false
        }
        else {
            self.navBar.isHidden = true
            
        }
        */
    }
    
    private func setupMenu() {
        let menuVC = MenuViewController()
        menuVC.delegate = self
        menu = SideMenuNavigationController(rootViewController: menuVC)
        menu?.leftSide = true
        menu?.menuWidth = 200
        menu?.presentationStyle = .menuSlideIn
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        // ekranı kaydırarak açma
        
    }
       
    private func setupCustomNavBar() {
        
        let statusBarHeight = Utils.shared.getStatusBarHeight()
        _ = statusBarHeight + self.view.safeAreaInsets.top
        
        view.addSubview(navBar)
        navBar.backgroundColor = AppColors.shared.bgColor
        
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60 + view.safeAreaInsets.top)
            // status bar + navBar yüksekliği
            
        }

         // Menü butonu
         menuButton.setImage(UIImage(systemName: "sideMenuIcon"), for: .normal)
         menuButton.tintColor = .white
         menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
         navBar.addSubview(menuButton)
        
        menuButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.width.height.equalTo(50)
            make.height.equalTo(50)
            
        }
        
         // Başlık
         titleLabel.text = "FlatnetSite\nYönetim Sistemi"
         titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
         titleLabel.textColor = .white
         titleLabel.numberOfLines = 2
         titleLabel.textAlignment = .center
         navBar.addSubview(titleLabel)
         
         titleLabel.snp.makeConstraints { make in
             make.center.equalToSuperview()
         }
     }
    
    private func setupNavBar() {
        /*
           navigationItem.leftBarButtonItem = UIBarButtonItem(
               title: "☰",
               style: .plain,
               target: self,
               action: #selector(openMenu)
           )
         
         
         let button = UIButton(type: .system)
         button.setImage(UIImage(named: "iconMenu"), for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 20) // daha büyük
         button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)

         navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)

         
         */
        
        let menuButton = UIBarButtonItem(
            title: "☰",
            style: .plain,
            target: self,
            action: #selector(openMenu)
        )

        // Fontu büyütelim
        menuButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 28)], for: .normal)
        menuButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 28)], for: .highlighted)

        navigationItem.leftBarButtonItem = menuButton

        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.text = "FlatnetSite\nYönetim Sistemi"

        self.navigationItem.titleView = titleLabel
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 71/255, green: 137/255, blue: 190/255, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
    }
       
       
    @objc private func openMenu() {
        if let menu = menu {
            present(menu, animated: true)
            
        }
    }
    
    private func logOutAlert() {
        

        presentAlert(
            title: "Uyarı",
            message: "Çıkış yapmak istediğinize emin misiniz?",
            actions: [
                (title: "Çıkış Yap", style: .default, handler: {
                    print("evet seçildi")
                    SVProgressHUD.show(withStatus: "Çıkış Yapılıyor")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                        self.logOut()
                    }

                }),
                (title: "Hayır", style: .destructive, handler: {
                    print("hayır seçildi")
                    
                })
            ]
        )
        
    }
       
    func logOut() {
                
        AuthManager.shared.logout()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())
            window.makeKeyAndVisible()
            
        }
        
        SVProgressHUD.dismiss(withDelay: 3.0)
    
    }
   
    private func openPopUp() {
        
        let popupVC = PopupViewController(
            title: "Belge Türü Seçiniz",
            options: ["Fotoğraf çek (Kamera)", "Galeriden fotoğraf seç", "Dosya seç"],
            confirmTitle: "Gönder"
        )
        popupVC.outputdelegate = self
        /*
        popupVC.onOptionSelected = { option in
            print("Seçilen: \(option)")
        }
        popupVC.onConfirm = {
            print("Gönder tıklandı")
            
        }
        */
        
        present(popupVC, animated: true)
        
    }
    
    
}

extension BaseVC: PopUpViewcontrollerDelegate {
    
    func didSelectOption(_ option: String) {
        
    }
    
    func didConfirm() {
        
        Utils.shared.showProgress()
        
        
        
    }
    
}

extension BaseVC: MenuViewControllerDelegate {
    
    // MARK: - MenuViewControllerDelegate
    func didSelectMenuItem(_ item: MenuItem) {
        switch item {
        case .profil:
            print("Profil seçildi")
            let vc = UserProfileViewController(with: .init())
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .kasaDurumu:
            print("Kasa Durumu seçildi")
            let vc = FinancialViewController(with: .init())
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .yeniTalep:
            print("Yeni talep seçildi")
            let vc = NewRequestCreateVC(with: .init())
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .siteKurallari:
            let vc = RulesViewController(with: .init())
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .oturumKapat:
            print("Çıkış yapılacak")
            self.logOutAlert()
            
        case .belgeYukle:
            print("belge yükleniyor")
            self.openPopUp()
            

        case .ustaRehberi:
            let vc = CraftsMenViewController(with: .init())
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
}
