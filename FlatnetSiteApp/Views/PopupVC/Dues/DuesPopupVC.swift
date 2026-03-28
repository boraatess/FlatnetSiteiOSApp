//
//  DuesPopupVC.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 27.09.2025.
//

import Foundation
import UIKit
import SnapKit
import iOSDropDown

protocol duesPopupVCDelegate: AnyObject {
    func didSelectOption(_ option: String)
    func didConfirm(with duesid: Int)
}

final class DuesPopupVC: UIViewController {
    
    private let headerView = UIView()

    private let containerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private let hstackView = UIStackView()
    private let stackView = UIStackView()
    private let confirmButton = UIButton(type: .system)
        
    private var options: [String] = []
    
    private var confirmTitle: String
    private var selectedID: Int
    
    let chooseDocDropDown = DropDown()

    // Callback’ler
    var onOptionSelected: ((String) -> Void)?
    var onConfirm: (() -> Void)?

    weak var outputdelegate: duesPopupVCDelegate?
    
    private var selectedFileURL: URL? {
        didSet {
            fileNameLabel.text = selectedFileURL?.lastPathComponent
        }
        
    }
    
    private let fileNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        lbl.text = "Henüz dosya seçilmedi"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var pickerHelper: FilePickerHelper?
    
    let viewModel = DuesPopupViewModel()
    
    var fileUploader = FileUploader()
    
    
    // MARK: - Init
    init(title: String, subTitle: String, options: [String], confirmTitle: String, duesID: Int) {
        self.options = options
        self.confirmTitle = confirmTitle
        self.selectedID = duesID
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        titleLabel.text = title
        subtitleLabel.text = subTitle
        confirmButton.setTitle(confirmTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileUploader.delegate = self
        viewModel.outputdelegate = self
        pickerHelper = FilePickerHelper(presentingVC: self)
        setupUI()
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        configureOptionsSelected()
        // Boşluğa tıklayınca kapansın
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOnBackgroundTap(_:)))
          tapGesture.cancelsTouchesInView = false
          view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func dismissOnBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    
    private func configureOptionsSelected() {
        onOptionSelected = { option in
            
            print("Secilen: \(option)")
            if option.contains("Kamera") {
                // kamera ac
                print("kamera açılıyor")
                let selectedFileUrl = self.pickFile(with: .camera)
                self.fileNameLabel.text = selectedFileUrl
            } else if option.contains("Galeriden") {
                // galeri ac
                print("galeriden seç")
                let selectedFileUrl = self.pickFile(with: .gallery)
                self.fileNameLabel.text = selectedFileUrl
            } else {
                // dosya sec
                print("dosya seç")
                let selectedFileUrl = self.pickFile(with: .document)
                self.fileNameLabel.text = selectedFileUrl
                
            }
            
        }
    }
    
    private func pickFile(with from: FileSource) -> String {
        
        var selectedFileurl = ""
        pickerHelper?.pickFile(from: from) { [weak self] url in
            
            guard let self = self else { return }
            
            if let fileURL = url {
                print("Seçilen dosya: \(fileURL.lastPathComponent)")
                self.selectedFileURL = fileURL
                
            } else {
                print("Dosya seçilmedi")
                selectedFileurl = "Dosya seçilmedi. Hata!"
                
            }
        }
        
        return selectedFileurl
    }
    
    
    @objc func confirmButtonClicked() {
        
        self.outputdelegate?.didConfirm(with: self.selectedID)
        
        // let fileUrl = self.selectedFileURL?.lastPathComponent ?? ""
        
        if let fileUrl = self.selectedFileURL {
            self.viewModel.sendReceiptRequest(with: self.selectedID, and: fileUrl)
            
        }
        else {
            Utils.shared.showAutoDismissAlert(title: "Uyarı!", message: "Lütfen bir fotoğraf veya dosya seçiniz.", duration: 2.0, viewController: self)
            
        }
        
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        containerView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(5)
        }
        headerView.backgroundColor = AppColors.shared.greenViewColor
        
        headerView.addSubview(hstackView)
        hstackView.axis = .vertical
        hstackView.spacing = 8
        hstackView.backgroundColor = AppColors.shared.greenViewColor
        hstackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(8)
        }
        
        hstackView.addArrangedSubview(titleLabel)
        hstackView.addArrangedSubview(subtitleLabel)
        
        containerView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // Dinamik seçenek butonları
        options.forEach { option in
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            button.backgroundColor = UIColor(white: 0.95, alpha: 1)
            button.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
            button.addAction(UIAction { [weak self] _ in
                self?.onOptionSelected?(option)
            }, for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
        
        stackView.addArrangedSubview(fileNameLabel)
        
        // Confirm button
        containerView.addSubview(confirmButton)
        confirmButton.backgroundColor = UIColor.systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        /*
        confirmButton.addAction(UIAction { [weak self] _ in
            self?.onConfirm?()
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
        */
        
    }
    
    private func showSuccesAlert() {
    
        DispatchQueue.main.async {
            self.presentAlert(title: "Yükleme Başarılı", message: "Yöneticinizin onayını bekleyiniz.", actions: [(title: "Tamam", style: .cancel, handler: nil)])
            
            Utils.shared.dismissProgress()
        }
    }
    
}

extension DuesPopupVC: FileUploaderDelegate {
    
    func checkUploadResult(success: Bool) {
        if success {
            self.showSuccesAlert()
            
        }
    }
    
}


extension DuesPopupVC: DuesPopupViewModelOutputDelegate {
    
    func showProgressAlert(with fileTotalSize: Float) {
        fileUploader.uploadFile(fileSize: fileTotalSize)
        
    }
    
    func showAlert(with title: String, and message: String) {
        
        DispatchQueue.main.async {
            Utils.shared.showAutoDismissAlert(title: title, message: message, duration: 2.0, viewController: self)
            
            
        }
        
    }
    
}
