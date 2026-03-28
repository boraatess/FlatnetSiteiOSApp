//
//  MyDemandsViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

// tabbar - talepler ekranı

import SnapKit
import UIKit

class MyDemandsViewController: BaseVC<MyDemandsViewmodel> {

    private let header = HeaderView(
           icon: UIImage(named: "factCheck"),
           title: "Taleplerim",
           subtitle: "Talepleriniz burada görüntülenir yeni talep açmak için sol menüyü kullanabilirsiniz."
       )
    
    private let warningHeader = HeaderView(
           icon: UIImage(named: "infoIcon"),
           title: "",
           subtitle: "Henüz bir talebiniz yok!. Apartman ve ya sitenizle ilgili bir istek, öneri veya şikayetiniz olursa, hemen yeni bir talep oluşturabilirsiniz."
       )
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.isHidden = true
        tableview.separatorStyle = .none
        tableview.contentInset = .zero
        tableview.sectionHeaderTopPadding = 0
        tableview.contentInsetAdjustmentBehavior = .automatic

        return tableview
    }()
    
    var requestsArray: [RequestArray] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MyDemandsCell.self, forCellReuseIdentifier: MyDemandsCell.identifier)
        setupLayout()
        viewModel.getRequests()
        tableView.addDefaultRefresh(target: self, action: #selector(onRefresh))
    }
    
    @objc func onRefresh() {
        viewModel.getRequests()
    }
    
}

extension MyDemandsViewController: MyDemandsViewmodelOutputProtocol {
    
    func fetchRequests(_ requests: RequestsResponse) {
                
        if let mArray = requests.data?.requests, mArray.count > 0 {
            self.requestsArray = mArray
            
            DispatchQueue.main.async {
                self.warningHeader.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.stopRefreshing()

            }
        }
        else {
            DispatchQueue.main.async {
                self.warningHeader.isHidden = false
                self.tableView.isHidden = true

            }
        }
        
    }
    
    func showError(with error: String) {
        
        
    }
    
}

extension MyDemandsViewController {
    
    func setupLayout() {
        
        view.backgroundColor = AppColors.shared.vcBgColor
        
        view.addSubview(header)
              
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        
        view.addSubview(warningHeader)
        warningHeader.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
            
        }
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            
            
        }
        
    }
    
}

extension MyDemandsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyDemandsCell.identifier, for: indexPath) as? MyDemandsCell else {
            return UITableViewCell()
        }
        
        let reqArray = requestsArray[indexPath.row]
        
        cell.cellConfigureMydemands(with: reqArray)
        
        cell.outputDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
}


extension MyDemandsViewController: MydemandsCellDelegate {
    
    func didTaponDetailButton(with request: RequestArray) {
        print("detail button tapped")
        print("request data: \(request)")
        
        let vc = RequestsDetailVC()
        // vc.navigationController?.setNavigationBarHidden(true, animated: false)
        vc.requestDetailModel = request
        vc.configure(with: request)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}

