//
//  TabbarViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = AppColors.shared.bgColor
        self.tabBar.unselectedItemTintColor = .darkGray
        
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupTabBar() {
        
        let homeVC =  UINavigationController(rootViewController: HomeViewController(with: .init()))
        homeVC.tabBarItem = UITabBarItem(title: "Duyurular", image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        
        let duesController =  UINavigationController(rootViewController: DuesViewController(with: .init()))
        duesController.tabBarItem = UITabBarItem(title: "Aidatlar", image: UIImage(named: "dashboard"), selectedImage: UIImage(named: "dashboardSelected"))
        
        let myDemandsController =  UINavigationController(rootViewController: MyDemandsViewController(with: .init()))
        myDemandsController.tabBarItem = UITabBarItem(title: "Taleplerim", image: UIImage(named: "factCheck"), selectedImage: UIImage(named: "factcheckSelected"))
        
        let surveyController =  UINavigationController(rootViewController: SurveysViewController(with: .init()))
        surveyController.tabBarItem = UITabBarItem(title: "Anketler", image: UIImage(named: "shield"), selectedImage: UIImage(named: "shieldSelected"))
        
        viewControllers = [homeVC, duesController, myDemandsController, surveyController]
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
           
        }
    }
    
  
}
