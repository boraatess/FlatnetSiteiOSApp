//
//  LoginViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import Foundation
import Combine
import FirebaseCrashlytics

protocol LoginViewModelOutputProtocol: ViewModelOutputProtocol {
    func goTabbar()
    func showError(message: String)
    func showAlert(title: String, message: String)
}

protocol LoginViewModelInputProtocol: ViewModelProtocol {
    func sendLoginRequest()
    func setPushNotificationToken()
}


class LoginViewModel: LoginViewModelInputProtocol {
   
    // typealias T = LoginViewModelOutputProtocol
    
    weak var outputDelegate: LoginViewModelOutputProtocol?
    
    @Published var email: String = ""
    @Published var password: String = ""
       
    var isLoginEnabled: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($email, $password)
            .map { !$0.isEmpty && !$1.isEmpty || $0.isEmpty && $1.isEmpty }
            .eraseToAnyPublisher()
    }
    
    func sendLoginRequest() {
        if email.isEmpty || password.isEmpty {
            print("email : \(email) password : \(password)")
            self.outputDelegate?.showError(message: "Email veya Şifre Boş Bırakılamaz!")
            self.outputDelegate?.showAlert(title: "", message: "Email veya Şifre Boş Bırakılamaz!")
        }
        else {
            print("email : \(email) password : \(password)")
            
            let url = Constants.shared.baseUrl + "/login"
            
            let loginRequest = LoginRequest(email: email, password: password)
            
            NetworkManager.shared.request( type: LoginResponse.self, url: url,
                method: .post, body: loginRequest ) { result in
               
                print(result)
                
                switch result {
                case .success(let response):
                    self.saveUser(with: response)
                    print("Login OK: \(response)")
                    self.setPushNotificationToken()
                    self.outputDelegate?.goTabbar()

                case .failure(let error):
                    print("Login failed: \(error)")
                    self.outputDelegate?.showError(message: error.localizedDescription)
                    self.checkError(with: error)
                    
                }
                
            }
        }
      
    }
    
    private func checkFcmToken() {
        
        let didSendToken = UserDefaults.standard.bool(forKey: "didSendFcmToken")
        
        if !didSendToken {
            setPushNotificationToken()
            
        }
        else {
            self.outputDelegate?.goTabbar()
            
        }
        
    }
    
    func setPushNotificationToken() {
        
        let token = UserDefaults.standard.string(forKey: "fcm_token") ?? ""

        Services.shared.setPushNotification(token: token) { response, error in
            
            if let result = response {
                print(result)
                
            }
            else {
                print(error ?? "Error!...")
                
            }
            
        }
        
    }
    
    
    func checkError(with error: ErrorTypes) {
        
        switch error {
            
        case .serverError(let statusCode):
            if statusCode == 401 {
                self.outputDelegate?.showAlert(title: "Uyarı!", message: "Email veya şifre hatalı")
            }
            else {
                self.outputDelegate?.showAlert(title: "Uyarı!", message: error.localizedDescription)
            }
            
        default
            : break
            
        }
    }
    
    func saveUser(with response: LoginResponse) {
        
        let user = response.data.user
       
        let userProfile = UserProfile(id: user.id, name: user.name, email: user.email, phoneNumber: user.phoneNumber ?? "", daireNo: user.daireNo, role: user.role, apartmentName: user.apartment?.name ?? "", blockName: user.block?.name ?? "", registirationDate: response.data.user.registrationDateString)
        
        Crashlytics.crashlytics().log("Kullanıcı girişi başladı")
        Crashlytics.crashlytics().setUserID(user.email)
        
        AuthManager.shared.saveSession(token: response.data.accessToken, user: userProfile)
        
        
    }
    
}
