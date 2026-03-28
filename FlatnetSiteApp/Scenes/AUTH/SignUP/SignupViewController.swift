//
//  SignupViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import UIKit
import SnapKit
import iOSDropDown


class SignupViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let shadowContainer = UIView()
    
    
    private let header = CustomHeader(
           icon: UIImage(named: "personAdd"),
           title: "Yeni Hesap Oluşturun",
           subtitle: "Apartman Yönetim Sistemi'ne katılmak için bilgileri doldurun."
       )
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🧑‍🤝‍🧑 Yeni Hesap Oluşturun"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Apartman Yönetim Sistemi'ne katılmak için bilgileri doldurun."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    private func makeTextField(placeholder: String, keyboardType: UIKeyboardType) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.keyboardType = keyboardType
        
        return tf
    }
    
    private let passwordTextField: PasswordTextField = {
        let tf = PasswordTextField()
        tf.placeholder = "En az 8 karakter"
        return tf
    }()
    
    private let confirmPasswordTF: PasswordTextField = {
        let tf = PasswordTextField()
        tf.placeholder = "Şifrenizi doğrulayın"
        return tf
    }()
    
    private let phoneTextField: PhoneNumberTextField = {
        let tf = PhoneNumberTextField()
        tf.maxLength = 10
        
        return tf
    }()
    
    private lazy var nameField = makeTextField(placeholder: "Adınız", keyboardType: .default)
    private lazy var surnameField = makeTextField(placeholder: "Soyadınız", keyboardType: .default)
    // private lazy var phoneField = makeTextField(placeholder: "(5xx) xxx xx xx", keyboardType: .phonePad)
    private lazy var emailField = makeTextField(placeholder: "E-Posta", keyboardType: .emailAddress)
    private lazy var apartmentField = makeTextField(placeholder: "Apartman", keyboardType: .default)
    private lazy var blockField = makeTextField(placeholder: "Blok", keyboardType: .default)
    private lazy var flatField = makeTextField(placeholder: "Daire Numarası", keyboardType: .default)
    
    private let termsCheckBox = UIButton(type: .custom)
    private let termsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.numberOfLines = 2
        return l
    }()
    
    private let kvkkCheckBox = UIButton(type: .custom)
    private let kvkkLabel: UILabel = {
        let l = UILabel()
        l.text = "KVKK Aydınlatma Metni'ni okudum."
        l.font = UIFont.systemFont(ofSize: 13)
        l.numberOfLines = 2
        return l
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hesap Oluştur", for: .normal)
        button.backgroundColor = UIColor.systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Zaten bir hesabınız var mı?"
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let backToLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Giriş Yapın", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    
    let viewModel = SignupViewModel()

    let apartmentDropDown = DropDown()
    let blockDropDown = DropDown()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.outputDelegate = self
        viewModel.getApartments()
        bindViewModel()
        setupLayout()
        backToLoginButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func registerButtonClicked() {
        
        if termsCheckBox.isSelected && kvkkCheckBox.isSelected {
            print("İkisi de seçili ✅")
            viewModel.acceptKvkk = true
            viewModel.acceptPrivacy = true
            viewModel.acceptTerms = true
            self.sendSignupRequest()
            
        } else {
            print("Eksik seçim ❌")
            
            DispatchQueue.main.async {
                Utils.shared.showAutoDismissAlert(title: "Uyarı!", message: "KVKK Metnini ve Gizlilik politikasını onaylayın.", duration: 2.0, viewController: self)
                
            }
            
        }
        
    }
    
    private func sendSignupRequest() {
        
        // let apartmentId = Int(apartmentDropDown.selectedRowColor.description) ?? 0
        // let blockId = Int(blockDropDown.selectedRowColor.description) ?? 0
        
        let email = emailField.text ?? ""
        let name = nameField.text ?? ""
        let surname = surnameField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirm = confirmPasswordTF.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        let daireNo = flatField.text ?? ""
        
        if !email.isEmpty && !name.isEmpty && !surname.isEmpty &&
            !password.isEmpty && !confirm.isEmpty &&
            !phoneNumber.isEmpty && !daireNo.isEmpty {
            
            self.viewModel.sendSignupRequest()
            
        }
        else {
            
            DispatchQueue.main.async {
                Utils.shared.showAutoDismissAlert(title: "Uyarı!", message: "Lütfen tüm gerekli alanları doldurunuz.", duration: 2.0, viewController: self)
                
            }
            
        }
        
    }
    
    @objc func goBack() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func setupDropdowns() {
        
    }
    
    private func bindViewModel() {
        
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        nameField.addTarget(self, action: #selector(nameFieldChanged), for: .editingChanged)
        surnameField.addTarget(self, action: #selector(surnameFieldChanged), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(phoneFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordFieldChanged), for: .editingChanged)
        confirmPasswordTF.addTarget(self, action: #selector(confirmPasswordFieldChanged), for: .editingChanged)
        flatField.addTarget(self, action: #selector(flatFieldChanged), for: .editingChanged)

        apartmentField.addTarget(self, action: #selector(apartmentFieldChanged), for: .editingChanged)
        blockField.addTarget(self, action: #selector(blockFieldChanged), for: .editingChanged)
        
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailField.text ?? ""
    }
    
    @objc private func nameFieldChanged() {
        viewModel.firstName = nameField.text ?? ""
    }
    
    @objc private func surnameFieldChanged() {
        viewModel.lastName = surnameField.text ?? ""
    }
    
    @objc private func phoneFieldChanged() {
        viewModel.phoneNumber = phoneTextField.cleanNumber
    }
    
    @objc private func passwordFieldChanged() {
        viewModel.password = passwordTextField.text ?? ""
    }
    
    @objc private func confirmPasswordFieldChanged() {
        viewModel.confirm = confirmPasswordTF.text ?? ""
    }
    
    @objc private func flatFieldChanged() {
        viewModel.daireNo = flatField.text ?? ""
    }
    
    @objc private func apartmentFieldChanged() {
        viewModel.apartmentID = Int(apartmentField.text ?? "") ?? 0
    }
    
    @objc private func blockFieldChanged() {
        viewModel.blockID = Int(blockField.text ?? "") ?? 0
        
    }
 
    
    private func makeCheckBoxRow(_ checkBox: UIButton ) -> UIStackView {
        let row = UIStackView(arrangedSubviews: [checkBox])
        row.axis = .horizontal
        row.spacing = 8
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)


        checkBox.addTarget(self, action: #selector(toggleCheckBox(_:)), for: .touchUpInside)
        checkBox.tintColor = .blue // icon rengi

        checkBox.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        return row
    }
    
    private func makeLoginRow() -> UIStackView {
        let leftSpacer = UIView()
        let rightSpacer = UIView()
        
        let row = UIStackView(arrangedSubviews: [leftSpacer, loginLabel, backToLoginButton, rightSpacer])
        row.axis = .horizontal
        row.spacing = 4
        row.alignment = .center
        row.distribution = .equalSpacing
        // burası önemli!
        
        return row
        
    }

    
    @objc private func toggleCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = .clear
    }

    
}

extension SignupViewController {
    
    // MARK: - Layout with SnapKit
    // MARK: - Layout
    private func setupLayout() {
        
        view.backgroundColor = AppColors.shared.vcBgColor
        
        view.addSubview(header)
              
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        emailField.textContentType = .emailAddress
        
        // ScrollView + Shadow Container
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        scrollView.addSubview(shadowContainer)
        shadowContainer.backgroundColor = .white
        shadowContainer.layer.cornerRadius = 12
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowOpacity = 0.1
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainer.layer.shadowRadius = 5
        
        shadowContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(20)
            make.left.right.equalTo(view).inset(16)
            make.width.equalTo(view).inset(16)
            make.bottom.equalTo(scrollView) // 🔑 scroll için gerekli
        }
        
        // ContentView
        shadowContainer.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(shadowContainer.snp.width)
        }
        
        let termsTextView = UITextView()
        termsTextView.isEditable = false
        termsTextView.isScrollEnabled = false
        termsTextView.delegate = self
        termsTextView.dataDetectorTypes = []
        termsTextView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let kvkkTextView = UITextView()
        kvkkTextView.isEditable = false
        kvkkTextView.isScrollEnabled = false
        kvkkTextView.delegate = self
        kvkkTextView.dataDetectorTypes = []
        kvkkTextView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let fullText = "Kullanım Şartları ve Gizlilik Politikası’nı okudum, kabul ediyorum."
        let attributedString = NSMutableAttributedString(string: fullText)

        // Kullanım Şartları linki
        if let range = fullText.range(of: "Kullanım Şartları") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.link, value: "app://terms", range: nsRange)
        }

        // Gizlilik Politikası linki
        if let range = fullText.range(of: "Gizlilik Politikası") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.link, value: "app://privacy", range: nsRange)
        }
        
        termsTextView.attributedText = attributedString
        
        let kvkkfullText = "KVKK Aydınlatma Metni'ni okudum."
        let attributedStr = NSMutableAttributedString(string: kvkkfullText)

        if let range = kvkkfullText.range(of: "KVKK Aydınlatma Metni") {
            let nsRange = NSRange(range, in: kvkkfullText)
            attributedStr.addAttribute(.link, value: "app://kvkk", range: nsRange)
        }
        
        kvkkTextView.attributedText = attributedStr
        
        let checkbox1 = makeCheckBoxRow(termsCheckBox)
        let checkbox2 = makeCheckBoxRow(kvkkCheckBox)
        
        checkbox1.addArrangedSubview(termsTextView)
        checkbox2.addArrangedSubview(kvkkTextView)
        
        // Form stack
        let formStack = UIStackView(arrangedSubviews: [
            nameField, surnameField, phoneTextField, emailField,
            apartmentDropDown, blockDropDown, flatField,
            passwordTextField, confirmPasswordTF,
            checkbox1, checkbox2,
            registerButton,
            makeLoginRow()
        ])
        
        // 📌 UI’ya ekle
        
        formStack.axis = .vertical
        formStack.spacing = 12
        contentView.addSubview(formStack)
        
        formStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(20) // 🔑 scroll için alt sabitleme
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
    }
    
    private func openUrl(with urlString: String) {
        let vc = ShowDocumentVC()
        vc.invoiceUrl = urlString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension SignupViewController: UITextViewDelegate {
    
    // iOS 16 ve öncesi
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString == "app://kvkk" {
            print("KVKK sayfasına yönlendir")
            let kvkkUrl = Constants.shared.kvkkUrl
            self.openUrl(with: kvkkUrl)
            return false
        }
        else if URL.absoluteString == "app://terms" {
            print("terms sayfasına yönlendir")
            let termsUrl = Constants.shared.termsOfUseUrl
            self.openUrl(with: termsUrl)
            return false
        }
        else if URL.absoluteString == "app://privacy" {
            print("privacy sayfasına yönlendir")
            let privacyUrl = Constants.shared.privacyUrl
            self.openUrl(with: privacyUrl)
            return false
        }
        
        return true
        
    }
       
}

    /*
    if #available(iOS 17.0, *) {
        return false // sistemin açmasını tamamen engelle
    } else {
        handleLink(URL)
        return false // kesinlikle false olmalı
    }
}

// iOS 17 ve sonrası
@available(iOS 17.0, *)
func textView(_ textView: UITextView,
              didTapOn link: URL,
              in characterRange: NSRange) {
    handleLink(link)
}

// Ortak yönlendirme
private func handleLink(_ url: URL) {
    switch url.absoluteString {
    case "app://kvkk":
        print("KVKK sayfasına yönlendir")
        openUrl(with: Constants.shared.kvkkUrl)
    case "app://terms":
        print("Terms sayfasına yönlendir")
        openUrl(with: Constants.shared.termsOfUseUrl)
    case "app://privacy":
        print("Privacy sayfasına yönlendir")
        openUrl(with: Constants.shared.privacyUrl)
    default:
        break
    }
}
*/


extension SignupViewController: SignupViewModelOutputDelegate {
    
    func showAlert(with title: String, and message: String) {

        DispatchQueue.main.async {
            
            self.presentAlert( title: title, message: message,
                actions: [
                    (title: "Tamam", style: .default, handler: {
                        print("evet seçildi")
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                ])
            
        }
        
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            Utils.shared.showAutoDismissAlert(title: "Hata!", message: message, duration: 2.0, viewController: self)
            
        }
        
    }
    
    func fetchApartments(with response: ApartmentsResponse) {
        
        // 1️⃣ Apartman DropDown
        DispatchQueue.main.async {
            self.apartmentDropDown.optionArray = response.data.map( { $0.name } )
            self.apartmentDropDown.placeholder = "Apartman seçin"
            self.apartmentDropDown.didSelect { (selectedText, index, id) in
                print("Apartman: \(selectedText)")
                let id = response.data[index].id
                self.viewModel.apartmentID = id
                self.viewModel.getBlockswithID(apartmentID: id)
                print("Apartman id : \(id)")
                
            }
        }
        
    }
    
    func fetchBlocks(with response: BlocksResponse) {
        
        DispatchQueue.main.async {
            // 2️⃣ Blok DropDown
            self.blockDropDown.optionArray = response.data.map( { $0.name } )
            self.blockDropDown.placeholder = "Blok seçin"
            self.blockDropDown.didSelect { (selectedText, index, id) in
                print("Blok: \(selectedText)")
                
                let id = response.data[index].id
                self.viewModel.blockID = id
                
            }
        }
        
    }
    
    
    func showSignupSuccess() {
        
        
    }
    
    func showSignupError(message: String) {
        
        
    }
    
    
    
}
