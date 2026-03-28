//
//  RulesViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import Foundation

protocol RulesViewModelInputDelegate: ViewModelProtocol {
    func getRules()
    
}

protocol RulesViewModelOutputDelegate: ViewModelOutputProtocol {
    func sendRules(sections: [RuleSection])
    func showError(message: String)
    
}


class RulesViewModel: RulesViewModelInputDelegate {
    
    typealias T = RulesViewModelOutputDelegate
    weak var outputDelegate: T?
    
    var sections: [RuleSection] = []
    
    func getRules() {
        
        let url = Constants.shared.baseUrl + "/rules"
        
        NetworkManager.shared.getRequest(type: RulesResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)
                self.generateSections(with: response)
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(message: error.localizedDescription)
            }
            
            
        }
        
    }
    
    func generateSections(with response: RulesResponse) {
        
        let array = response.data
        
        array.forEach { rule in
            
            let newElement = RuleSection(title: rule.title, content: rule.content, isExpanded: false)
            
            sections.append(newElement)
            
        }
        
        self.outputDelegate?.sendRules(sections: sections)
        
        
        
    }
    
    
}
