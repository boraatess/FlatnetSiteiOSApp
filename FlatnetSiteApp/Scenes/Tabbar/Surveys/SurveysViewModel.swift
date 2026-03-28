//
//  SurveysViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 11.09.2025.
//

import Foundation

protocol SurveysViewModelOutputProtocol: ViewModelOutputProtocol {
    func sendSurveys(_ surveys: SurveysResponse)
    func showError(with title: String, and message: String)
    func displayedSurveys(_ surveys: [SurveySection])
    func showVoteResults(with results: PollResult)
}


protocol SurveysViewModelInputProtocol: ViewModelProtocol {

    func getAllSurveys()
}


class SurveysViewModel: SurveysViewModelInputProtocol {
    
    typealias T = SurveysViewModelOutputProtocol
    weak var outputDelegate: T?
    
    var surveySections: [SurveySection] = []
    
    @Published var optionId: Int = 0

    
    func getAllSurveys() {
    
        let url = Constants.shared.pollsEnpoint
        
        NetworkManager.shared.getRequest(type: SurveysResponse.self, method: .get, url: url) { result in
            
            switch result {
                
            case .success(let response):
                print(response)

                self.generateSections(with: response)
                self.outputDelegate?.sendSurveys(response)

            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(with: "Uyarı!", and: error.localizedDescription)
                
                
            }
            
        }
        
        
    }
    
    func generateSections(with respones: SurveysResponse) {
        
        self.surveySections.removeAll()
        
        let surveys = respones.data.polls
        
        surveys.forEach { survey in
            
            let newSurvey = SurveySection(id: survey.id, sectionTitle: survey.question, createdAt: survey.createdAt, items: survey.options, isExpanded: false, hasVoted: survey.hasVoted)
            
            self.surveySections.append(newSurvey)
            
        }
        
        self.outputDelegate?.displayedSurveys(surveySections)
        
    }
    
    func sendVotewithSelectedOption(with pollid: Int, and options: [Option]) {
        
        print("oylama gönderiliyor... id : \(self.optionId)")
        
        let optionids = options.map({$0.id})
        
        if optionids.contains(self.optionId) {
            
            print("evet içeriyor")
            sendVoteRequest(with: pollid)
        }
        
        else {
            print("hayır içermiyor")
            self.outputDelegate?.showError(with: "Uyarı!", and: "Lütfen seçiminizi kontrol ediniz.")
            
        }
        
    }
    
    func getVotedPollResult(with pollid: Int) {
        
        let url = Constants.shared.pollsEnpoint + "/\(pollid)/results"

        NetworkManager.shared.getRequest(type: VotedPollResult.self, method: .get, url: url) { result in
            
            
            switch result {
                
                case .success(let response):
                  print(response)
                guard let pollData = response.data else { return }
                self.outputDelegate?.showVoteResults(with: pollData)
                
                case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(with: "Hata!", and: "Beklenmeyen bir hata oluştu.")
                
            }
        
        }
        
        
    }
    
    private func sendVoteRequest(with pollid: Int) {
        
        let url = Constants.shared.pollsEnpoint + "/\(pollid)/vote"
        
        print(url)
        
        let voteRequest = PollRequest(optionID: self.optionId)
        
        NetworkManager.shared.request(type: PollVoteResponse.self, url: url, method: .post, body: voteRequest) { result in
            
            print(result)
            
            switch result {
                
            case .success(let response):
                print(response)
                self.outputDelegate?.showError(with: "Başarılı!", and: response.data?.msg ?? "Oyunuz Başarıyla kaydedildi.")
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(with: "Uyarı!", and: error.localizedDescription)
            }
            
        }
        
    }
    
    
}

