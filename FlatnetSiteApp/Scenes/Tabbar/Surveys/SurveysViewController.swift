//
//  SurveysViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

// tabbar - anketlerim ekranı 

import Foundation
import UIKit
import SnapKit

class SurveysViewController: BaseVC<SurveysViewModel> {

    private let header = HeaderView(
           icon: UIImage(named: "shield"),
           title: "Aktif Anketler",
           subtitle: "Yaşam alanın ile ilgili bir çok konuda karar sahibisin."
       )
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.backgroundColor = .systemGray6
        tableview.contentInset = .zero
        tableview.sectionHeaderTopPadding = 5
        tableview.contentInsetAdjustmentBehavior = .never
        tableview.separatorStyle = .none
        return tableview
    }()
    
    var surveys: [SurveySection] = []
    var surveysArray: [Surveys] = []

    var selectedIndex: Int? = nil
    var selectedIndexes: [Int: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        viewModel.getAllSurveys()
        tableView.register(SurveysTableviewCell.self, forCellReuseIdentifier: SurveysTableviewCell.identifier)
        tableView.addDefaultRefresh(target: self, action: #selector(onRefresh))

        
    }
    
    @objc func onRefresh() {
        viewModel.getAllSurveys()
        
    }
    
}

extension SurveysViewController {
    
    func layout() {
      
        view.backgroundColor = AppColors.shared.vcBgColor
        
        /*
        view.addSubview(customHeader)
        
        customHeader.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }*/
        
        view.addSubview(header)
              
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
    }
    
    
}

extension SurveysViewController: SurveysViewModelOutputProtocol {
    
    func showVoteResults(with results: PollResult) {
        
        let question = results.question ?? ""
        let totalVotes = results.totalVotes
        let resultsData = results.results
        
        var results: [(String, Double, Int)] = []
        
        resultsData?.forEach { resultArr in
            
            let mResult = [(resultArr.text ?? "", resultArr.percentage ?? 0, resultArr.votes ?? 0)]
            
            results.append(contentsOf: mResult)
        }
        
        DispatchQueue.main.async {
            let vc = PollResultsVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.questionText = question
            vc.totalVotesText = "Toplam \(String(describing: totalVotes)) Oy Kullanıldı"
            vc.results = results
            self.present(vc, animated: true)
        }
      
    }
    
    func displayedSurveys(_ surveys: [SurveySection]) {
        self.surveys = surveys
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.stopRefreshing()

        }
        
    }
    
    func showError(with title: String, and message: String) {
        print(message)
        
        DispatchQueue.main.async {
            Utils.shared.showAutoDismissAlert(title: title, message: message, duration: 2.0, viewController: self)
            
        }
    }
    
    func sendSurveys(_ surveys: SurveysResponse) {
        print("tüm anketler : \(surveys)")
        
    }
    
    
}


extension SurveysViewController: UITableViewDelegate, UITableViewDataSource, SurveysTableviewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return surveys.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemsCount = surveys[section].items.count
        let survey = surveys[section]
        if survey.hasVoted {
            return 0 // sonuçlar ekranına gidecek, burada satır yok
            
        } else {
            return survey.isExpanded ? itemsCount : 0
            // +1 = "Oyu Gönder" butonu için
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SurveysTableviewCell.identifier, for: indexPath) as? SurveysTableviewCell
        else {
            return UITableViewCell()
        }
        let option = surveys[indexPath.section].items[indexPath.row]
        
        // let isSelected = indexPath.row == selectedIndex
        let isselected = selectedIndexes[indexPath.section] == indexPath.row

        cell.configure(with: option, and: isselected)
        
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexes[indexPath.section] = indexPath.row
        tableView.reloadSections([indexPath.section], with: .automatic)
        
        let cell = tableView.cellForRow(at: indexPath) as? SurveysTableviewCell
        cell?.notifySelection()
        
    }
    
    func didSelectOption(id: Int) {
        
        print("option with id: \(id) is selected")
        viewModel.optionId = id
        
        
    }
      
    
    // MARK: - Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width-16, height: 100))
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        
        let sectionTitle = UILabel(frame: CGRect(x: 16, y: 8, width: view.frame.width-16, height: 20))
        sectionTitle.textColor = .black
        sectionTitle.numberOfLines = 0
        sectionTitle.font = .boldSystemFont(ofSize: 14)
        sectionTitle.text = surveys[section].sectionTitle
        
        let createdAt = UILabel(frame: CGRect(x: 16, y: 36, width: view.frame.width-56, height: 10))
        createdAt.textColor = .black
        createdAt.numberOfLines = 0
        createdAt.font = .systemFont(ofSize: 10)
        let createdAtString = surveys[section].createdAt
        createdAt.text = createdAtString.formattedDate()
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 10, y: 60, width: Int(view.frame.width), height: 40)
        if surveys[section].hasVoted {
            button.setTitle("Oy kullandınız, sonuçları gör", for: .normal)
        }
        else {
            button.setTitle("Oylamaya Katıl", for: .normal)
        }
        
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = AppColors.shared.butonIndıgoColor
        button.layer.cornerRadius = 6
        button.tag = section
        button.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
        
        view.addSubview(sectionTitle)
        view.addSubview(createdAt)
        view.addSubview(button)
        
        return view
    }
    
    // ✅ Section Footer: "Oyu Gönder" butonu burada
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let button = UIButton(type: .system)
         button.setTitle("Oyu Gönder", for: .normal)
         button.backgroundColor = AppColors.shared.butonIndıgoColor
         button.setTitleColor(.white, for: .normal)
         button.layer.cornerRadius = 8
         button.tag = section
         button.addTarget(self, action: #selector(sendVoteTapped(_:)), for: .touchUpInside)
         
         let container = UIView()
         container.addSubview(button)
         button.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             button.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
             button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
             button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
             button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
             button.heightAnchor.constraint(equalToConstant: 45)
         ])
         return container
     }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         //     return polls[section].selectedIndex != nil ? 60 : 0
         // let itemsCount = surveys[section].items.count
         let survey = surveys[section]
         
         if survey.hasVoted {
             return 0
         } else {
             return survey.isExpanded ? 60 : 0
         }
                  
     }
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 116
    }
       
    @objc private func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        let hasVoted = surveys[section].hasVoted
        
        if hasVoted {
            print("anket sonuçları getiriliyor...")
            let pollid = surveys[section].id
            viewModel.getVotedPollResult(with: pollid)
        }
        else {
            // expand/collapse toggle
            surveys[section].isExpanded.toggle()
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
        
    }
    
    @objc func sendVoteTapped(_ sender: UIButton) {
        print("Section \(sender.tag) için Oyu Gönder")
        
        let options = surveys[sender.tag].items
        let pollid = surveys[sender.tag].id
        
        viewModel.sendVotewithSelectedOption(with: pollid, and: options)
        
    }
    
    
    
}
