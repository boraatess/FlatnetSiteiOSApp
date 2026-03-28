//
//  HomeViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

// tabbar - duyurular ekranı


import UIKit
import SnapKit

class HomeViewController: BaseVC<HomeViewModel> {
    
    private let header = HeaderView(
           icon: UIImage(named: "volumeUP"),
           title: "Duyurular",
           subtitle: "Toplantılar, alınan kararlar ve herhangi bir duyuru buradan paylaşılır."
       )
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .systemBackground
        tableview.separatorStyle = .none
        tableview.contentInsetAdjustmentBehavior = .automatic
        return tableview
    }()
    
    var announcements: [Announcement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        viewModel.getAnnouncements()
        tableView.register(HomeTableviewCell.self, forCellReuseIdentifier: HomeTableviewCell.identifier)
        tableView.addDefaultRefresh(target: self, action: #selector(onRefresh))
        
    }
    
    @objc func onRefresh() {
        viewModel.getAnnouncements()
        
    }
    
}

extension HomeViewController: HomeViewModelOutputProtocol {
    
    func sendAnnouncements(_ announcements: AnnouncementsResponse) {
        print("duyurular data : \(announcements)")
        self.announcements = announcements.data.announcements
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.stopRefreshing()

        }
        
        Utils.shared.dismissProgress()

    }
    
    func showError(with message: String) {
        
    }
    
    
}


extension HomeViewController {
    
    func setupLayout() {
        
        view.backgroundColor = AppColors.shared.vcBgColor
        
        /*   view.addSubview(customHeader)
         customHeader.snp.makeConstraints { make in
             make.top.equalTo(self.view.safeAreaLayoutGuide)
             make.leading.trailing.equalToSuperview()
             make.height.equalTo(80)
         }
         */
        
        view.addSubview(header)
        header.backgroundColor = .white
        
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcements.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableviewCell.identifier, for: indexPath) as? HomeTableviewCell
        
        let announcement = self.announcements[indexPath.row]
        
        cell?.configureViews(with: announcement)
        cell?.selectionStyle = .none
        
        
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
}
