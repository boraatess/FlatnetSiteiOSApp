//
//  SplashViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation

protocol SplashViewModelInputDelegate: AnyObject {
    func checkUser()
    func setPushNotification()
}

protocol SplashViewModelOutputDelegate: AnyObject {
    func appStartWithLogin()
    func appStartWithTabbar()
    func showSuccessPushnotify(with token: String)
}


class SplashViewModel: SplashViewModelInputDelegate {
    
    weak var outputdelegate: SplashViewModelOutputDelegate?
    
    func checkUser() {
        
        if AuthManager.shared.isLoggedIn {
            print("Token:", AuthManager.shared.accessToken ?? "")
            print("User:", AuthManager.shared.currentUser?.name ?? "")
            self.setPushNotification()
            self.outputdelegate?.appStartWithTabbar()
            
        } else {
            self.outputdelegate?.appStartWithLogin()
            
        }
        
    }
    
    private func checkFcmToken() {
        
        // Gerçek cihaz kontrolü
        
#if targetEnvironment(simulator)
        // Eğer simülatördeysek, API'ye gönderme işlemini atla.
        
        print("Simulator algılandı. FCM Token API'ye gönderilmeyecek.")
        self.outputdelegate?.appStartWithTabbar()
        
#endif
        
        
        let didSendToken = UserDefaults.standard.bool(forKey: "didSendFcmToken")
        
        if !didSendToken {
            setPushNotification()
        }
        else {
            self.outputdelegate?.appStartWithTabbar()
            
        }
        
    }
    
    internal func setPushNotification() {
    
        let token = UserDefaults.standard.string(forKey: "fcm_token") ?? ""
                
        Services.shared.setPushNotification(token: token) { response, error in
            
            if let result = response {
                print(result)
                UserDefaults.standard.set(true, forKey: "didSendFcmToken")
                
            }
            else {
                print(error ?? "Error!...")
                
                
            }
            
        }
        
    }
    
    
}
