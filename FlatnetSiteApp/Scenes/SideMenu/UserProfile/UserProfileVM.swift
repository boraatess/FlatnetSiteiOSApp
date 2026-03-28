//
//  UserProfileVM.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import Foundation

protocol UserProfileVMInputDelegate: ViewModelProtocol {
    func fetchUserProfile()
    func deleteUserprofileRequest(with password: String)
}

protocol UserProfileVMOutputDelegate: ViewModelOutputProtocol {
    func updateUserProfile(userProfile: UserProfile)
    func fetchUserDocs(with displayedSections: displayedSections)
    func showError(with title: String, and error: String)
    func showSuccessDelete()
    
}


class UserProfileVM: UserProfileVMInputDelegate {
 
    
    typealias T = UserProfileVMOutputDelegate
    weak var outputDelegate: T?
    
    
    func fetchUserProfile() {
        
        let userProfile = AuthManager.shared.currentUser!
        self.outputDelegate?.updateUserProfile(userProfile: userProfile)
        
    }
    
    func deleteUserprofileRequest(with password: String) {
        
        let url = Constants.shared.deleteProfileEndpoint

        let request = DeleteProfileRequest(password: password)
        
        NetworkManager.shared.request(type: LoginResponse.self, url: url, method: .post, body: request) { result in
            
            print(result)
            
            switch result {
                
            case .success(let response):
                print(response)
                
                self.outputDelegate?.showSuccessDelete()
                
            case .failure(let error):
                print(error)
                self.outputDelegate?.showError(with: "Hata!", and: error.localizedDescription)
                
                
            }
            
        }
        
    }
    
    
    func getUserDocuments() {
        
        let url = Constants.shared.docsEndpoint
        
        NetworkManager.shared.getRequest(type: DocumentsResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                self.generateDisplayedSections(with: response)
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(with: "Hata!", and: error.localizedDescription)
                
            }
            
        }
        
        
    }
    
    func generateDisplayedSections(with response: DocumentsResponse) {
        
        // var docsArray: [displayedDocuments] = []
        
        if let documents = response.data {
            
            let section = displayedSections(imageName: "", sectionName: "Yüklediğim Belgeler", documents: documents, isExpanded: false)
            
            self.outputDelegate?.fetchUserDocs(with: section)

        }
        
        
    }
    
    
}
