//
//  FinancialViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import UIKit
import SnapKit


class FinancialViewController: BaseVC<FinancialViewModel> {
        
  
    private let header = HeaderView(
           icon: UIImage(named: "dollar"),
           title: "Kasa Durumu",
           subtitle: ""
       )
    
    private let newHeader = FinancialHeader(icon: UIImage(named: "dollar"), title: "Kasa Durumu", subtitle: "")
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .singleLine
        tableview.allowsSelection = false
        tableview.backgroundColor = .white
        tableview.layer.cornerRadius = 8
        
        return tableview
    }()
    
    var expenseList: [Expense] = []
    var incomeList: [Income] = []
    
    var financialList: ExpenseData?
    
    private var monthName: String? {
        didSet {
            if let period = monthName {
                let subtitle = "\(period) Ayı Finansal Özeti"
                newHeader.setSubtitletext(with: subtitle)
            }
           
        }
    }
    
    private var totalAmount: String? {
        didSet {
            if let displayAmount = totalAmount {
                let subtitle = "\(displayAmount)"
                newHeader.setTotalAmounttext(with: subtitle)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        viewModel.getFinancials()
        registerCells()
        
        
    }
    
    private func registerCells() {
        tableView.register(IncomeCell.self, forCellReuseIdentifier: IncomeCell.identifier)
                
        tableView.register(ExpenseCell.self, forCellReuseIdentifier: ExpenseCell.identifier)
        tableView.register(SummaryHeaderView.self, forHeaderFooterViewReuseIdentifier: SummaryHeaderView.identifier)
        

    }
    
}

extension FinancialViewController: FinancialViewModelOutputDelegate {
    
    func configureView(with monthName: String, and displayTotalAmount: String) {
        
        print("dönem : \(monthName), toplam : \(displayTotalAmount)")
        
        DispatchQueue.main.async {
            self.monthName = monthName
            self.totalAmount = displayTotalAmount
        }
      
    }
    
    func showError(with message: String) {
        
    }
    
    func sendExpenselist(with list: ExpenseData) {
        self.expenseList = list.expenseList
        self.incomeList = list.incomeList
        self.financialList = list
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
        
    }
    
    
}

extension FinancialViewController {
    
    func setupLayout() {
        
        view.backgroundColor = AppColors.shared.vcBgColor
        
        view.addSubview(newHeader)
              
        newHeader.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.newHeader.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        
    }
    
    
}

extension FinancialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.incomeList.count : self.expenseList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // ✅ IncomeCell
            let model = self.incomeList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomeCell.identifier, for: indexPath) as! IncomeCell
            cell.configure(with: model)
            cell.selectionStyle = .none
            
            return cell
        } else {
            // ✅ ExpenseCell
            let model = self.expenseList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseCell.identifier, for: indexPath) as! ExpenseCell
            
            cell.configure(with: model)
            
            // Butona action ekle
            // cell.invoiceButton.tag = indexPath.row
            
            cell.outputDelegate = self
            cell.selectionStyle = .none
            
            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SummaryHeaderView.identifier) as? SummaryHeaderView else {
            return nil
        }
        
        if section == 0 {
            let totalIncome = self.financialList?.totalIncomeDisplay ?? "0.00"
            header.configure(title: "Gelirler", totalAmount: totalIncome, isIncome: true)
        } else {
            let totalExpense = self.financialList?.totalExpenseDisplay ?? "0.00"
            header.configure(title: "Giderler", totalAmount: totalExpense, isIncome: false)
        }
        
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}


extension FinancialViewController: ExpenseCellOutputDelegate {
    
    func invoiceButtonTapped(for invoiceUrl: String) {
        
        print(invoiceUrl)
        if !invoiceUrl.isEmpty {
            let vc = ShowDocumentVC()
            vc.invoiceUrl = invoiceUrl
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else {
            DispatchQueue.main.async {
                Utils.shared.showAutoDismissAlert(title: "HATA!", message: "Belge bulunamadı.", duration: 2.0, viewController: self)
                
            }
           
        }
       
        
    }
    
}
