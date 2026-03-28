//
//  HomeViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 10.09.2025.
//

import Foundation

protocol HomeViewModelOutputProtocol: ViewModelOutputProtocol {
    func sendAnnouncements(_ announcements: AnnouncementsResponse)
    func showError(with message: String)
}


protocol HomeViewModelInputProtocol: ViewModelProtocol {
    func getAnnouncements()
}


class HomeViewModel: HomeViewModelInputProtocol {
    
    typealias T = HomeViewModelOutputProtocol
    weak var outputDelegate: T?
    
    // announcements
    
    func getAnnouncements() {
        
        Utils.shared.showProgress()
        
        let url = Constants.shared.baseUrl + "/announcements"
        
        NetworkManager.shared.getRequest(type: AnnouncementsResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case . success(let response):
                print(response)
                self.outputDelegate?.sendAnnouncements(response)
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(with: error.localizedDescription)
                
            }
            
        }
            
    }
    
}
