//
//  DuesViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 11.09.2025.
//

import Foundation

protocol DuesViewModelOutputProtocol: ViewModelOutputProtocol {
    func showError(with message: String)
    func configureData(with response: DuesResponse, and displayTotalAmount: String)
}


protocol DuesViewModelInputProtocol: ViewModelProtocol {
    func getDues()
}


class DuesViewModel: DuesViewModelInputProtocol {
    
    typealias T = DuesViewModelOutputProtocol
    weak var outputDelegate: T?
    
    func getDues() {
        
        let url = Constants.shared.baseUrl + "/dues"
     
        NetworkManager.shared.getRequest(type: DuesResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                self.configureData(with: response)
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(with: error.localizedDescription)
                
            }
            
        }
        
    }
    
    func configureData(with response: DuesResponse) {
        
        let displayTotalAmount = response.data.totalDebtDisplay
        
        self.outputDelegate?.configureData(with: response, and: displayTotalAmount)
        
        
    }
    
}


