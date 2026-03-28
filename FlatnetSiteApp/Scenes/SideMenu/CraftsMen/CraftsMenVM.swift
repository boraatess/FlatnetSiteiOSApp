//
//  CraftsMenVM.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import Foundation

protocol CraftsMenVMInputDelegate: ViewModelProtocol {
    func getCraftsMenlist()
    func getCraftsmanByid(with id: Int)
}

protocol CraftsMenVMOutputDelegate: ViewModelOutputProtocol {
    func didGetCraftsMenlist(_ craftsmen: CraftsmenResponse)
    func showError(_ error: String)
}

class CraftsMenVM: CraftsMenVMInputDelegate {
 
    typealias T = CraftsMenVMOutputDelegate
    weak var outputDelegate: T?
    
    
    func getCraftsMenlist() {
        
        let url = Constants.shared.baseUrl + "/craftsmen"
        
        NetworkManager.shared.getRequest(type: CraftsmenResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                self.outputDelegate?.didGetCraftsMenlist(response)
            case .failure(let error):
                print(error.localizedDescription)
                
                
                
            }
            
        }
        
    }
    
    func getCraftsmanByid(with id: Int) {
                
        let url = Constants.shared.craftsmenEndpoint + "\(id)/request"
        
        NetworkManager.shared.getRequest(type: CraftsmenResponse.self, method: .post, url: url) { result in
            
            print(result)
            
            switch result {
                
            case .success(let response):
                print(response)
                self.outputDelegate?.didGetCraftsMenlist(response)
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(error.localizedDescription)
                
            }
            
        }
    
    }
    
}
