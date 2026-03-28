//
//  RulesViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import UIKit
import SnapKit


class RulesViewController: BaseVC<RulesViewModel> {
    
    private let header = HeaderView( icon: UIImage(systemName: "checklist"),
           title: "Site Yaşam Kuralları", subtitle: "Huzurlu bir ortak yaşam alanı için lütfen aşağıdaki kurallara uyunuz." )
    
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.rowHeight = UITableView.automaticDimension
        tableview.backgroundColor = .systemGray6
        tableview.contentInset = .zero
        tableview.sectionHeaderTopPadding = 0
        tableview.contentInsetAdjustmentBehavior = .never

        return tableview
    }()
    
    var rulesSection: [RuleSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getRules()
        setupLayout()
        tableView.register(RulesHeaderView.self, forHeaderFooterViewReuseIdentifier: RulesHeaderView.identifier)
        tableView.register(RulesTableviewCell.self, forCellReuseIdentifier: RulesTableviewCell.identifier)
        
    }
    
    
}

extension RulesViewController {
    
    private func setupLayout() {
        
        view.backgroundColor = AppColors.shared.vcBgColor
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

extension RulesViewController: RulesViewModelOutputDelegate {
    
    func sendRules(sections: [RuleSection]) {
        self.rulesSection = sections
        print("displayed sections : \(sections)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
        
    }
    
    func showError(message: String) {
        
    }
    
}

extension RulesViewController: UITableViewDelegate, UITableViewDataSource, RulesHeaderViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rulesSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rulesSection[section].isExpanded ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RulesTableviewCell.identifier, for: indexPath) as? RulesTableviewCell
        else {
            return UITableViewCell()
        }
        let html = rulesSection[indexPath.section].content

        cell.setHtml(html)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }


    // MARK: - Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RulesHeaderView.identifier) as? RulesHeaderView else { return nil }
        
        let title = rulesSection[section].title
        let expanded = rulesSection[section].isExpanded
        
        header.configure(title: title, section: section, isExpanded: expanded)
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func headerTapped(section: Int) {
        
        rulesSection[section].isExpanded.toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        
    }

    @objc private func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        rulesSection[section].isExpanded.toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
        
    }
    
    
    
}
