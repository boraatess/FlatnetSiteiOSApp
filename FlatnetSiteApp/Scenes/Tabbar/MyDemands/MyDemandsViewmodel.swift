//
//  MyDemandsViewmodel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 11.09.2025.
//

import Foundation

protocol MyDemandsViewmodelOutputProtocol: ViewModelOutputProtocol {
    func fetchRequests(_ requests: RequestsResponse)
    func showError(with error: String)
}


protocol MyDemandsViewmodelInputProtocol: ViewModelProtocol {
    func getRequests()
    
}


class MyDemandsViewmodel: MyDemandsViewmodelInputProtocol {
    
    typealias T = MyDemandsViewmodelOutputProtocol
    weak var outputDelegate: T?
    
    
    func getRequests() {
        
        let url = Constants.shared.requestEndpoint
        
        
        NetworkManager.shared.getRequest(type: RequestsResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                self.outputDelegate?.fetchRequests(response)
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(with: error.localizedDescription)
                
            }
            
        }
        
        
    }
    
}

