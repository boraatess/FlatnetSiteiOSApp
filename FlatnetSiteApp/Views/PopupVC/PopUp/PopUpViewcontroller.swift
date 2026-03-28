//
//  PopUpViewcontroller.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 26.09.2025.
//

import Foundation
import UIKit
import SnapKit
import iOSDropDown

protocol PopUpViewcontrollerDelegate: AnyObject {
    func didSelectOption(_ option: String)
    func didConfirm()
}

final class PopupViewController: UIViewController {
    
    private let containerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Belge Türü Seçiniz"
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView = UIStackView()
    private let confirmButton = UIButton(type: .system)
    
    private var dropDownOptions: [String] = ["Kira Kontratı", "Kimlik(Maskeli)", "Ruhsat", "Aşı Karnesi", "Taşınma Belgesi", "Tadilat İzni", "Ek hane halkı", "Diğer"]
    
    private var options: [String] = []
    
    private var confirmTitle: String
    
    let chooseDocDropDown = DropDown()

    // Callback’ler
    var onOptionSelected: ((String) -> Void)?
    var onConfirm: (() -> Void)?

    weak var outputdelegate: PopUpViewcontrollerDelegate?
    
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

    let viewModel = PopupViewModel()
    
    private var selectedDocType: String = ""
    
    var fileUploader = FileUploader()
    
    // MARK: - Init
    init(title: String, options: [String], confirmTitle: String) {
        self.options = options
        self.confirmTitle = confirmTitle
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        titleLabel.text = title
        confirmButton.setTitle(confirmTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileUploader.delegate = self
        viewModel.outputDelegate = self
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
    
    @objc func confirmButtonClicked() {
        print(selectedFileURL?.lastPathComponent ?? "")
        let fileUrl = self.selectedFileURL?.lastPathComponent ?? ""
        
        if self.selectedDocType.isEmpty || fileUrl.isEmpty {
            Utils.shared.showProgress()
            Utils.shared.showAutoDismissAlert(title: "Uyarı!", message: "Lütfen makbuz belgenizi ve türünü seçiniz.", duration: 2.0, viewController: self)
            Utils.shared.dismissProgress()
            
        }
        else {
            if let fileUrl = self.selectedFileURL {
                Utils.shared.showProgress()
                self.viewModel.sendReceiptRequest(with: self.selectedDocType, and: fileUrl)
                
            }
        }
        
    }
    
    private func configureOptionsSelected() {
        onOptionSelected = { option in
            
            print("Secilen: \(option)")
            if option.contains("Kamera") {
                // kamera ac
                print("kamera açılıyor")
                self.pickFile(with: .camera)
                
            } else if option.contains("Galeriden") {
                // galeri ac
                print("galeriden seç")
               self.pickFile(with: .gallery)
                
            } else {
                // dosya sec
                print("dosya seç")
                self.pickFile(with: .document)
                
            }
            
        }
    }
    
    private func pickFile(with from: FileSource) {
        
        if from == .camera {
            pickerHelper?.checkCameraUsability { [weak self] usable in
                
                guard let self = self else { return }
                
                if usable {
                    self.openPicker(from: from)
                    
                }
                else {
                    Utils.shared.showAutoDismissAlert(title: "Kamera İzni Gerekli", message: "Kamera kullanabilmek için ayarlardan izin vermeniz gerekiyor.", duration: 3.0, viewController: self)
                    
                }
                
            }

        }
        else {
            self.openPicker(from: from)
            
        }
        
    }
    
    private func openPicker(from source: FileSource) {
        pickerHelper?.pickFile(from: source) { [weak self] url in
            guard let self = self else { return }
            
            if let fileURL = url {
                print("Seçilen dosya: \(fileURL.lastPathComponent)")
                self.selectedFileURL = fileURL
            } else {
                print("Dosya seçilmedi")
            }
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
        
        containerView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        containerView.addSubview(chooseDocDropDown)
        chooseDocDropDown.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        containerView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.snp.makeConstraints { make in
            make.top.equalTo(chooseDocDropDown.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        chooseDocDropDown.optionArray = self.dropDownOptions
        self.chooseDocDropDown.placeholder = "Belge türü seçiniz"
        
        chooseDocDropDown.didSelect { (selectedText, index, id) in
            print("doc type: \(selectedText)")
            self.selectedDocType = selectedText
            
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
            
        }, for: .touchUpInside)
        */
        
    }
    
}

extension PopupViewController: PopupViewModelOutputDelegate {
    
    func showErrorAlert(with title: String, and message: String) {
        DispatchQueue.main.async {
            
            Utils.shared.showAutoDismissAlert(title: title, message: message, duration: 2.0, viewController: self)
            
            Utils.shared.dismissProgress()
            
        }
        
    }
    
    func showProgressAlert(with fileTotalSize: Float) {
        
        fileUploader.uploadFile(fileSize: fileTotalSize)
        
    }
    
    func showAlert(with title: String, and message: String) {
        
        
        
    }

    
}

extension PopupViewController: FileUploaderDelegate {
    
    func checkUploadResult(success: Bool) {
        
        if success {
            
            DispatchQueue.main.async {
                
                self.presentAlert(title: "Yükleme Başarılı", message: "Yöneticinizin onayını bekleyiniz.", actions: [(title: "Tamam", style: .cancel, handler: nil)])
                
                Utils.shared.dismissProgress()

                                
            }
            
        }
        
    }
    
}
