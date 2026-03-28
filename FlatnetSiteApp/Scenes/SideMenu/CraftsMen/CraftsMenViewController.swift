//
//  CraftsMenViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import UIKit
import SnapKit

class CraftsMenViewController: BaseVC<CraftsMenVM> {
    
    private let header = HeaderView(
           icon: UIImage(named: "settingsAccountBox"),
           title: "Usta Rehberi",
           subtitle: "İhtiyacınız olan servisler için yöneticinizin önerdiği ustalara buradan ulaşabilirsiniz."
       )
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        tableview.backgroundColor = .systemBackground
        return tableview
    }()
    
    var craftsmenList: [CraftsmenData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        viewModel.getCraftsMenlist()
        tableView.register(CraftsmenTableviewCell.self, forCellReuseIdentifier: CraftsmenTableviewCell.identifier)
    }
    
    
}

extension CraftsMenViewController {
    
    func setupLayout() {
        
        view.backgroundColor = .white
        
        view.addSubview(header)
              
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        
        /*
        view.addSubview(customHeader)
        customHeader.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }*/
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
    
        
    }
    
}


extension CraftsMenViewController: CraftsMenVMOutputDelegate {
    
    func showError(_ error: String) {
        
    }
    
    func didGetCraftsMenlist(_ craftsmen: CraftsmenResponse) {
        print(craftsmen)
        self.craftsmenList = craftsmen.data
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
        
    }
    
    
}

extension CraftsMenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return craftsmenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CraftsmenTableviewCell.identifier, for: indexPath) as? CraftsmenTableviewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let craftsmen = craftsmenList[indexPath.row]
        
        cell.configureCell(with: craftsmen)
        cell.outputdelegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}


extension CraftsMenViewController: CraftsmenCellOutputDelegate {
    
    func callButtonClicked(with craftsmanID: Int) {
        print("call button tapped")

        self.viewModel.getCraftsmanByid(with: craftsmanID)
        
    }
    
    
}
