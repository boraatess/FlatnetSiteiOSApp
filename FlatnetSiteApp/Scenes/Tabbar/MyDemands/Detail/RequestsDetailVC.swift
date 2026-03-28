//
//  RequestsDetailVC.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 29.09.2025.
//

import Foundation
import UIKit
import SnapKit


class RequestsDetailVC: UIViewController {
    
    // MARK: - UI
    
    private var headerView: MydemandsHeader = {
        let header = MydemandsHeader()
        
        return header
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let createdLabel: UILabel = {
        let label = UILabel()
        label.text = "Olusturulma:"
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    private let updatedLabel: UILabel = {
        let label = UILabel()
        label.text = "Guncellenme:"
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textAlignment = .right
        return label
    }()
    
    /*
    private let statusButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 6
        return button
    }()
    */
    
    private let statusLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.backgroundColor = .systemYellow
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    /*
    private let adminAnswerLabel: PhoneButton = {
        let btn = PhoneButton()
     
        return btn
    }()
    */
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "chatSymbol")
        iv.tintColor = AppColors.shared.butonIndıgoColor
        return iv
    }()
    
    private let adminAnswerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.text = "Yönetici Yanıtı"
        return lbl
    }()
    
    // yatay
    private let hStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        sv.distribution = .fill
        return sv
    }()
    
    private let answerLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.isUserInteractionEnabled = false
        lbl.layer.cornerRadius = 8
        lbl.numberOfLines = 0
        lbl.tintColor = AppColors.shared.labelbgColor
        
        return lbl
    }()
    
    private let openDocument: ReceiptButton = {
        let button = ReceiptButton()
        button.isHidden = true
        
        return button
    }()
    
    private let titleRow = InfoRowView(title: "Baslik:", value: "")
    private let categoryRow = InfoRowView(title: "Kategori:", value: "")
    private let priorityRow = InfoRowView(title: "Oncelik:", value: "")
    private let locationRow = InfoRowView(title: "Konum:", value: "")
    private let descriptionRow = InfoRowView(title: "Aciklama:", value: "")
    private let fileRow = InfoRowView(title: "Dosya Eki:", value: "-")

    var requestDetailModel: RequestArray? {
        didSet {
            if let model = requestDetailModel {
                self.configure(with: model)
                self.setValuetext(with: model)
                
            }
        }
        
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        setupLayout()
        openDocument.addTarget(self, action: #selector(openFileButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationbar()
    }
    
    @objc func openFileButtonTapped() {
        
        print("open file tapped")
        
        if let fileUrl = requestDetailModel?.attachmentURL {
            let vc = ShowDocumentVC()
            vc.invoiceUrl = fileUrl
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        
    }
    
    private func setupNavigationbar() {
        let titleLabel = UILabel()
        titleLabel.text = "Talep Detayı"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black

        let iconImageView = UIImageView(image: UIImage(named: "documentSearch"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .black

        // stackview ile yan yana koy
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center

        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            
        }
        
        navigationItem.titleView = stack
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
                
        view.addSubview(headerView)
        view.addSubview(contentContainer)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview()
            
        }
        
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }
        
        // Content StackView
        let stack = UIStackView(arrangedSubviews: [
            titleRow,
            categoryRow,
            priorityRow,
            locationRow,
            descriptionRow,
            fileRow,
            openDocument
        ])
        stack.axis = .vertical
        stack.spacing = 8
        contentContainer.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        contentContainer.addSubview(spacerView)
        contentContainer.addSubview(hStackView)
        contentContainer.addSubview(answerLabel)
        
        spacerView.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
            
        }
        
        hStackView.addArrangedSubview(iconImageView)
        hStackView.addArrangedSubview(adminAnswerLabel)
        hStackView.addArrangedSubview(UIView())
        
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        hStackView.snp.makeConstraints { make in
            make.top.equalTo(spacerView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(20)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(self.hStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        
    }
    
    func setValuetext(with model: RequestArray) {
        titleRow.textValue = model.title
        categoryRow.textValue = model.category
        locationRow.textValue = model.location
        descriptionRow.textValue = model.description
        priorityRow.textValue = model.priority
        descriptionRow.textValue = model.description

        if let fileUrl = model.attachmentURL {
            openDocument.isHidden = false
            openDocument.configure(title: "Belgeyi Aç", image: UIImage(named: "attachFile"))
        }
        else {
            fileRow.textValue = "-"
            openDocument.isHidden = true
        }
        
        if let status = model.statusDisplay {
            
            switch status.color {
                
            case "success":
                let statusColor = AppColors.shared.successColor
                headerView.updateStatusColors(bgColor: statusColor, textColor: .white)
            case "info":
                let statusColor = AppColors.shared.warningColor
                headerView.updateStatusColors(bgColor: statusColor, textColor: .black)
            default :
                break
                
            }
            
        }
        
        answerLabel.text = model.reply
        
        
    }
    
    func configure(with model: RequestArray) {
        if let title = model.title, let cat = model.category,
           let prio = model.priority, let location = model.location,
           let desc = model.description {
            titleRow.updateValue(title)
            categoryRow.updateValue(cat)
            locationRow.updateValue(location)
            priorityRow.textValue = prio
            descriptionRow.updateValue(desc)
        }
        
        if let fileUrl = model.attachmentURL {
            openDocument.isHidden = false
            openDocument.configure(title: "Belgeyi Aç", image: UIImage(named: "attachFile"))

        }
        else {
            fileRow.updateValue("-")
            openDocument.isHidden = true
            
        }
        
        if let formattedCreated = model.createdAt?.formattedDate(),
           let formattedUpdated = model.updatedAt?.formattedDate(), let statusDisplay = model.statusDisplay?.text {
            
            headerView.configure(status: statusDisplay, statusColor: .systemYellow, createdAt: formattedCreated, updatedAt: formattedUpdated)
        }
        
        if let status = model.statusDisplay {
            switch status.color {
            case "success":
                let statusColor = AppColors.shared.successColor
                headerView.updateStatusColors(bgColor: statusColor, textColor: .white)
            case "info":
                let statusColor = AppColors.shared.warningColor
                headerView.updateStatusColors(bgColor: statusColor, textColor: .black)
            default :
                break
                
            }
        }
        
        if let reply = model.reply {
            answerLabel.text = reply
        }
        else {
            answerLabel.isHidden = true
            iconImageView.isHidden = true
            adminAnswerLabel.isHidden = true
            
        }
        
    }
    
}

// MARK: - Helper Component
class InfoRowView: UIView {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    var textValue: String? {
        didSet {
            self.valueLabel.text = textValue
            
        }
    }
    
    init(title: String, value: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        
        // valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textAlignment = .left
        valueLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .top
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateValue(_ text: String) {
        valueLabel.text = text
    }
    
}
