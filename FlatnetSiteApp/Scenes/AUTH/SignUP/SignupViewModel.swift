//
//  SignupViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.09.2025.
//

import Foundation

/*
 
 📦 Giden body JSON: {"apartment_id":2,"password":"Br.12345678","accept_kvkk":true,"first_name":"my test",
 
 "confirm_password":"Br.12345678",  "accept_terms":true,"accept_privacy":true,  "email":"boraatess95@gmail.com",    "phone_number":"5534373835","daire_no":"12","last_name":"user"}
 
 */


protocol SignupViewModelInputDelegate: AnyObject {
    func sendSignupRequest()
    func getApartments()
    func getBlockswithID(apartmentID: Int)
}

protocol SignupViewModelOutputDelegate: AnyObject {
    func showAlert(with title: String, and message: String)
    func showSignupSuccess()
    func showSignupError(message: String)
    func showError(message: String)
    func fetchApartments(with response: ApartmentsResponse)
    func fetchBlocks(with response: BlocksResponse)
    
}

class SignupViewModel: SignupViewModelInputDelegate {
    
    weak var outputDelegate: SignupViewModelOutputDelegate?
    
    @Published var acceptKvkk: Bool = false
    @Published var acceptPrivacy: Bool = false
    @Published var acceptTerms: Bool = false

    @Published var apartmentID: Int = 0
    @Published var blockID: Int = 0

    @Published var confirm: String = ""
    @Published var daireNo: String = ""
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var password: String = ""
    @Published var phoneNumber: String = ""
    
    func sendSignupRequest() {
        
        // curl -X POST "https://www.flatnetsite.com/api/v1/register"
        
        let url = Constants.shared.baseUrl + "/register"
        
        let requestBody = RegisterRequest(acceptKvkk: acceptKvkk, acceptPrivacy: acceptPrivacy, acceptTerms: acceptTerms, apartmentID: apartmentID,
                                          blockID: blockID == 0 ? nil : blockID, confirmPassword: confirm, daireNo: daireNo, email: email,
                                          firstName: firstName, lastName: lastName, password: password, phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber)
  
        print("request model \(requestBody)")
        
        NetworkManager.shared.request(type: RegisterResponse.self, url: url, method: .post, body: requestBody) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                let msg = response.msg
                self.outputDelegate?.showAlert(with: "Hoşgeldiniz!", and: msg ?? "")
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showSignupError(message: error.localizedDescription)
                self.outputDelegate?.showError(message: "Teknik bir hata meydana geldi. Lütfen tekrar deneyin.")
                
            }
            
        }

        
        /*
      
        */
        
    }
    
    func getApartments() {
        
        let url = Constants.shared.apartmentsEndpoint
        
        NetworkManager.shared.getRequest(type: ApartmentsResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                self.outputDelegate?.fetchApartments(with: response)
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(message: error.localizedDescription)
                
            }
            
        }
        
    }
    
    func getBlockswithID(apartmentID: Int) {
        
        let url = Constants.shared.apartmentsEndpoint + "/\(apartmentID)/blocks"
        
        NetworkManager.shared.getRequest(type: BlocksResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                self.outputDelegate?.fetchBlocks(with: response)
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(message: error.localizedDescription)
                
            }
            
        }
        
        
    }
    
    
}
