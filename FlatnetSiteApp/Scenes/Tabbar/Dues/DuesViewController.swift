//
//  DuesViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

// tabbar - aidatlar ekranı

import SnapKit
import UIKit
import FirebaseCrashlytics

class DuesViewController: BaseVC<DuesViewModel> {

    private let header = HeaderView(
           icon: UIImage(named: "dollar"),
           title: "Aidat ve Ödeme Geçmişi",
           subtitle: ""
       )
    
    private let warningHeader = HeaderView(
           icon: UIImage(named: "checkCircle"),
           title: "Tebrikler!",
           subtitle: "Geçmişe dönük veya güncel bir aidat borcunuz bulunmamaktadır."
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
    
    var duesList: [DuesList] = []
    
    var displayTotalAmount: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setupLayout()
        viewModel.getDues()
        tableView.register(DuesTableviewCell.self, forCellReuseIdentifier: DuesTableviewCell.identifier)
        tableView.addDefaultRefresh(target: self, action: #selector(onRefresh))

    }
    
    @objc func onRefresh() {
        viewModel.getDues()
        
        
    }
}

extension DuesViewController {
    
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
        
        warningHeader.configureIcon(.systemGreen)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        let text = "Toplam Borcunuz: \(self.displayTotalAmount)"
        let attributedString = NSMutableAttributedString(string: text)

        // "₺1.000,00" kısmını renklendirelim
        if let range = text.range(of: "\(self.displayTotalAmount)") {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: nsRange)
        }
        
        header.setLabelsAttributedText(with: "Aidat ve Ödeme Geçmişi", and: attributedString)
        
    }
    
}

extension DuesViewController: DuesViewModelOutputProtocol {
    
    func showError(with message: String) {
        print(message)
        
    }
    
    func configureData(with response: DuesResponse, and displayTotalAmount: String) {
        
        let mArray = response.data.duesList
        
        if mArray.count > 0 {
            
            self.displayTotalAmount = displayTotalAmount
            
            self.duesList = mArray
            
            DispatchQueue.main.async {
                self.setupLayout()
                self.warningHeader.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.stopRefreshing()

            }
            
            
        }
        else {
            self.displayTotalAmount = "₺0.00"

            DispatchQueue.main.async {
                self.setupLayout()
                self.warningHeader.isHidden = false
                self.tableView.isHidden = true
                
            }
        }
        
       
        
    }
    
}

extension DuesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DuesTableviewCell.identifier, for: indexPath) as? DuesTableviewCell
        else {
            return UITableViewCell()
        }
        
        let due = duesList[indexPath.row]
        
        cell.cellConfigure(with: due)
        cell.delegate = self
        
        return cell
        
    }
    
    
}

extension DuesViewController: DuesTableviewCellDelegate {
    
    func sendReceiptClicked(with period: String, and totalPrice: String, _ duesId: Int) {
        let options =  ["Fotoğraf çek (Kamera)", "Galeriden fotoğraf seç", "Dosya seç"]
        
        let title = "Dönem: \(period)"
        let totalValue = "Tutar: \(totalPrice)"
        
        DispatchQueue.main.async {
            let vc = DuesPopupVC(title: title, subTitle: totalValue, options: options, confirmTitle: "Gönder", duesID: duesId)
            vc.outputdelegate = self
            // callback ile seçimi yakala
            vc.onOptionSelected = { selected in
                /*
                print("Secilen: \(selected)")
                if selected.contains("Kamera") {
                    // kamera ac
                    print("kamera açılıyor")
                    
                } else if selected.contains("Galeriden") {
                    // galeri ac
                    print("galeriden seç")

                } else {
                    // dosya sec
                    print("dosya seç")

                }*/
                
            }
            vc.onConfirm = {
                
                print("gonderiliyor")
                
            }
                   
            self.present(vc, animated: true)
            
        }
        
    }
    
    func didTaponReceiptButton() {
        
        Crashlytics.crashlytics().log("🚀 Firebase Crashlytics log testi")
        
        Crashlytics.crashlytics().setCustomValue("simulator", forKey: "env")
           
        print("✅ Crashlytics log çalıştı")
        
    }
    
}

extension DuesViewController: duesPopupVCDelegate {
    
    func didConfirm(with duesid: Int) {
        print("selected dues id: \(duesid)")
        
        
    }
    
}
