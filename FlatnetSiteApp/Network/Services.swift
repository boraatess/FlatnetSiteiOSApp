//
//  Services.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation

class Services {
    
    static let shared = Services()
    
    func setPushNotification(token: String, successCompletion: @escaping ((PushNotifyResponse?, String?) -> Void)) {
        
        let url = Constants.shared.pushNotificationEndpoint
        
        let request = PushNotification(platform: "ios", service: "FCM", token: token)
        
        NetworkManager.shared.request(type: PushNotifyResponse.self, url: url, method: .post, body: request) { result in
            
            print(result)
            
            switch result {
                
            case.success(let response):
                successCompletion(response,nil)
                print(response)
                
                break
            case .failure(let error):
                successCompletion(nil, error.localizedDescription)
                print(error.localizedDescription)
                
                break
            }
            
        }
        
    }
    
    
}
