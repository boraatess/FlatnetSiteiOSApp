//
//  ForgotPasswordVM.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.09.2025.
//

import Foundation
import Combine

protocol ForgotPasswordInputDelegate: ViewModelProtocol {
    func sendPasswordResetEmail()
    
}

protocol ForgotPasswordOutputDelegate: ViewModelOutputProtocol {
    
    func showErrorMessage(_ message: String)
    func showAlert(with title: String, and message: String)
    
}

class ForgotPasswordVM: ForgotPasswordInputDelegate {
  
    
    typealias T = ForgotPasswordOutputDelegate
    weak var outputDelegate: T?
    
    @Published var email: String = ""

    
    func sendPasswordResetEmail() {
        
        if email.isEmpty {
            self.outputDelegate?.showErrorMessage("Lütfen email adresini giriniz.")
            
        }
        else {
            let url = Constants.shared.baseUrl + "/forgot-password"
            
            let request = ForgotPassword(email: email)
            
            NetworkManager.shared.request(type: ForgotPasswordResponse.self, url: url, method: .post, body: request) { result in
                
                switch result {
                    
                case .success(let response):
                    print(response)
                    let message = response.data.msg.decodedUnicode
                    
                    self.outputDelegate?.showAlert(with: response.msg, and: message)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.outputDelegate?.showErrorMessage(error.localizedDescription)
                    
                }
                
                
            }
            
        }
        
    }
    
    
    
}
