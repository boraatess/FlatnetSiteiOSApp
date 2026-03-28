//
//  FinancialViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import Foundation

protocol FinancialViewModelInputDelegate: ViewModelProtocol {
    func getFinancials()
}

protocol FinancialViewModelOutputDelegate: ViewModelOutputProtocol {
    func configureView(with monthName: String, and displayTotalAmount: String)
    func sendExpenselist(with list: ExpenseData)
    func showError(with message: String)
}


class FinancialViewModel: FinancialViewModelInputDelegate {
    
    typealias T = FinancialViewModelOutputDelegate
    weak var outputDelegate: T?
       
    
    func getFinancials() {
        
        let url = Constants.shared.financialsEnpoint
        
        NetworkManager.shared.getRequest(type: FinancialResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                self.fetchData(with: response)
                self.outputDelegate?.sendExpenselist(with: response.data)
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(with: error.localizedDescription)
                
            }
            
        }
        
    }
    
    func fetchData(with data: FinancialResponse) {
        
        let monthName = data.data.currentMonthName
        
        let displayAmount = data.data.totalBalanceDisplay
        self.outputDelegate?.configureView(with: monthName, and: displayAmount)
        
        
    }
    
    
}
