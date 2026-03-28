//
//  NewRequestCreateVC.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import UIKit
import SnapKit
import PhotosUI
import SVProgressHUD


class NewRequestCreateVC: BaseVC<NewRequestCreateVM> {
   
    private let header = HeaderView(
           icon: UIImage(named: "formsAddon"),
           title: "Yeni Talep Oluştur",
           subtitle: "Aklına gelen her konuda talepte bulunabilirsiniz. Yönetici tarafından incelenip cevap verilir." )
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
     
    private let titleField = UITextField()
    private let descriptionTextView = UITextView()
    
    private let categoryField = UITextField()
    private let priorityField = UITextField()
    private let locationField = UITextField()
    
    private let pickerView = UIPickerView()

    // Servisten gelecek datalar
    private var categories: [Category] = []
    private var priorities: [Category] = []
    private var locations: [Category] = []
    
    // Şu an hangi textfield için picker açıldı
    private var activeField: UITextField?
    private let addFileButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    private let submitButton = UIButton(type: .system)
    
    private var pickerHelper: FilePickerHelper?

    var fileUploader = FileUploader()

    private var selectedFileURL: URL? {
        didSet {
            // fileNameLabel.text = selectedFileURL?.lastPathComponent
            let buttonTitle = "Seçildi: \(selectedFileURL?.lastPathComponent ?? "")"
            addFileButton.setTitle(buttonTitle, for: .normal)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fileUploader.delegate = self
        pickerHelper = FilePickerHelper(presentingVC: self)
        titleField.addTarget(self, action: #selector(titleFieldChanged), for: .editingChanged)
        descriptionTextView.delegate = self
        setupUI()
        configurePickerview()
        viewModel.getRequestOptions()
    }
    
    private func configurePickerview() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // inputView olarak picker atıyoruz
        categoryField.inputView = pickerView
        priorityField.inputView = pickerView
        locationField.inputView = pickerView
        
        categoryField.placeholder = "Seçiniz"
        priorityField.placeholder = "Seçiniz"
        locationField.placeholder = "Seçiniz"
        
        // TextField focus olduğunda hangi field olduğunu anlayalım
        [categoryField, priorityField, locationField].forEach { field in
            field.delegate = self
        }
                
        
    }
    
    @objc private func titleFieldChanged() {
        viewModel.title = titleField.text ?? ""
    }
    
    private func setupUI() {
        
        view.backgroundColor = AppColors.shared.vcBgColor
        
        view.addSubview(header)
              
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
   
        // ScrollView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        // StackView
        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.alignment = .fill
        contentStack.distribution = .equalSpacing
        contentStack.backgroundColor = .white
        contentStack.layer.cornerRadius = 6
        
        
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
            // top, left, right, bottom scrollView içerisine sabitleniyor
            make.width.equalTo(scrollView.snp.width).inset(8)
            
            // yatay scroll engelle
        }
        
        // Alanları stack içine ekleyelim
        addLabeledField(label: "Başlık", field: titleField)
        addLabeledTextView(label: "Açıklama", textView: descriptionTextView, height: 250)
        addLabeledField(label: "Kategori", field: categoryField)
        addLabeledField(label: "Öncelik", field: priorityField)
        addLabeledField(label: "Konum/Alan", field: locationField)
        
        // Foto / Belge Ekle
        addFileButton.setTitle("Foto / Belge Ekle", for: .normal)
        addFileButton.backgroundColor = AppColors.shared.butonIndıgoColor
        addFileButton.setTitleColor(.white, for: .normal)
        addFileButton.layer.cornerRadius = 6
        addFileButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        contentStack.addArrangedSubview(addFileButton)
        
        // Alt Butonlar (yan yana)
        let buttonStack = UIStackView(arrangedSubviews: [clearButton, submitButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        buttonStack.distribution = .fillEqually
        
        clearButton.setTitle("Temizle", for: .normal)
        clearButton.backgroundColor = .darkGray
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.layer.cornerRadius = 6
        
        submitButton.setTitle("Gönder", for: .normal)
        submitButton.backgroundColor = AppColors.shared.butonIndıgoColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 6
        
        buttonStack.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        contentStack.addArrangedSubview(buttonStack)
        
        submitButton.addTarget(self, action: #selector(sumbitButtonTapped), for: .touchUpInside)
        addFileButton.addTarget(self, action: #selector(addFilebuttonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        
    }
    
    @objc func clearButtonTapped() {
        let allFields = [titleField, descriptionTextView, categoryField, priorityField, locationField]
        
        resetFields(allFields)
        
        
    }
    
    @objc func sumbitButtonTapped() {
        
        SVProgressHUD.show(withStatus: "Gönderiliyor...")
        
        let title = titleField.text ?? ""
        let description = descriptionTextView.text ?? ""
        let category = categoryField.text ?? ""
        let priority = priorityField.text ?? ""
        let location = locationField.text ?? ""
        
        if !title.isEmpty && !description.isEmpty && !category.isEmpty
            && !priority.isEmpty && !location.isEmpty {
            
            print("correct fields")
            
            self.viewModel.sendCreateNewRequest(with: self.selectedFileURL)

        }
        else {
            print("check fields")
            Utils.shared.showAutoDismissAlert(title: "Uyarı!", message: "Lütfen tüm gerekli alanları doldurunuz.", duration: 3.0, viewController: self)
            SVProgressHUD.dismiss()
            
        }
        
    }
    
    @objc func addFilebuttonTapped() {
        openFileOptions()
        
    }
    
    func openFileOptions() {
        
        presentAlert(
            title: "Dosya Ekler",
            message: "",
            actions: [
                (title: "Kamera", style: .default, handler: {
                    print("kamera açılıyor")
                    self.pickFile(with: .camera)
                    
                }),
                (title: "Fotoğraf Seç", style: .default, handler: {
                    print("fotoğraf seçiliyor")
                    self.pickFile(with: .gallery)
                    
                }),
                (title: "Dosya Seç", style: .default, handler: {
                    print("dosya seçiliyor")
                    self.pickFile(with: .document)
                    
                }),
                (title: "İptal", style: .cancel, handler: {
                    print("iptal seçildi")
                    
                })
            ]
        )
        
    }
    
    private func pickFile(with from: FileSource) {
        
        pickerHelper?.pickFile(from: from) { [weak self] url in
            
            guard let self = self else { return }
            
            if let fileURL = url {
                print("Seçilen dosya: \(fileURL.lastPathComponent)")
                self.selectedFileURL = fileURL
                
            } else {
                print("Dosya seçilmedi")
                
            }
        }
        
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }
    
    // MARK: - Helpers
    private func addLabeledField(label: String, field: UITextField) {
        let labelView = UILabel()
        labelView.text = label
        labelView.font = UIFont.boldSystemFont(ofSize: 14)
        
        field.borderStyle = .roundedRect
        field.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        let stack = UIStackView(arrangedSubviews: [labelView, field])
        stack.axis = .vertical
        stack.spacing = 8
        contentStack.addArrangedSubview(stack)
    }
       
    private func addLabeledTextView(label: String, textView: UITextView, height: CGFloat) {
        let labelView = UILabel()
        labelView.text = label
        labelView.font = UIFont.boldSystemFont(ofSize: 14)
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 6
        textView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
        let stack = UIStackView(arrangedSubviews: [labelView, textView])
        stack.axis = .vertical
        stack.spacing = 8
        contentStack.addArrangedSubview(stack)
        
    }
    
}

extension NewRequestCreateVC: NewRequestCreateVMOutputDelegate {
    
    func showProgressAlert(with fileTotalsize: Float) {
        self.fileUploader.uploadFile(fileSize: fileTotalsize)
    }
    
    func configureOptions(categories: [Category], locations: [Category], priorities: [Category]) {
        self.categories = categories
        self.locations = locations
        self.priorities = priorities
        
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func showAlert(with title: String, and message: String) {
        DispatchQueue.main.async {
            self.presentAlert(title: "Başarılı", message: "Talebiniz başarıyla oluşturuldu.",
                              actions: [(title: "Tamam", style: .cancel, handler: nil)])
            
        }
        
        SVProgressHUD.dismiss()

        
    }
    
    func showError(_ error: String) {
        SVProgressHUD.dismiss()
        
    }
    
}

extension NewRequestCreateVC: FileUploaderDelegate {
    
    func checkUploadResult(success: Bool) {
        
        if success {
            DispatchQueue.main.async {
                self.presentAlert(title: "Başarılı", message: "Talebiniz başarıyla oluşturuldu.",
                                  actions: [(title: "Tamam", style: .cancel, handler: nil)])
                
            }
            
        }
        
    }
    
}

extension NewRequestCreateVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        // viewModel.description = textView.text
        viewModel.descriptionTextview = textView.text
        print("ViewModel'e gönderildi:", viewModel.description)
        
    }
    
}

extension NewRequestCreateVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == categoryField {
            return categories.count
        } else if activeField == priorityField {
            return priorities.count
        } else if activeField == locationField {
            return locations.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == categoryField {
            return categories[row].value
        } else if activeField == priorityField {
            return priorities[row].value
        } else if activeField == locationField {
            return locations[row].value
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeField == categoryField {
            categoryField.text = categories[row].value
            viewModel.category = categories[row]
            
        } else if activeField == priorityField {
            priorityField.text = priorities[row].value
            viewModel.priority = priorities[row]
            
        } else if activeField == locationField {
            locationField.text = locations[row].value
            viewModel.location = locations[row]
            
        }
    }
    
    
}


extension NewRequestCreateVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        pickerView.reloadAllComponents()
    }
    
    
}

