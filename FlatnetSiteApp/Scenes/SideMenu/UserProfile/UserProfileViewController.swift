//
//  UserProfileViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import UIKit
import SnapKit


class UserProfileViewController: BaseVC<UserProfileVM> {
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Profil başlığı
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Profil Bilgileri"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    // Profil Kartı
    private let profileCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.circle"))
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()
    
    // Belgeler Bölümü
    private let documentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let documentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Yüklediğim Belgeler"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var docsTableView: ContentSizedTableView = {
        let tableview = ContentSizedTableView()
        tableview.layer.masksToBounds = false
        tableview.separatorStyle = .none
        tableview.contentInset = .init(top: 10, left: .zero, bottom: .zero, right: .zero)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.allowsMultipleSelection = true
        tableview.isScrollEnabled = false
        tableview.backgroundColor = .white
        
        return tableview
    }()
    
    // Tehlikeli Bölge
    private let dangerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let dangerHeader: UILabel = {
        let label = UILabel()
        label.text = "⚠️ Tehlikeli Bölge"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        return label
    }()
    
    private let dangerText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.text = "Hesabınızı kalıcı olarak silmek istediğinizden emin misiniz?\nBu işlem geri alınamaz.\n\nTüm kişisel verileriniz anonimleştirilecek ve sisteme erişiminiz sonlandırılacaktır."
        return label
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Hesabımı Sil", for: .normal)
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.tintColor = .white
        
        return btn
    }()
    
    private let infoStack = UIStackView()

    var displayedSections: displayedSections?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemGray6
        layout()

        viewModel.fetchUserProfile()
        viewModel.getUserDocuments()
        viewModel.outputDelegate = self
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
        docsTableView.register(DocumentsTableviewCell.self, forCellReuseIdentifier: DocumentsTableviewCell.identifier)
        
        
    }
    
    @objc func deleteButtonClicked() {
        
        // ViewController içinden
        presentAlert(
            title: "Uyarı",
            message: "Hesabınızı silmek istediğinize emin misiniz?",
            actions: [
                (title: "Hayır", style: .cancel, handler: {
                    print("Hayır seçildi")
                    
                }),
                (title: "Evet", style: .default, handler: {
                    print("evet seçildi")
                    self.showDeleteprofileAlert()
                    
                })
            ]
        )

        
    }
    
    private func setupProfileInfo(data: UserProfile) {
        
        nameLabel.text = data.name
        roleLabel.text = data.role
        
        
        infoStack.arrangedSubviews.forEach { $0.removeFromSuperview() } // temizle
        
        let rows = [
            ProfileInfoRow(title: "Telefon Numarası:", value: data.phoneNumber),
            ProfileInfoRow(title: "E-posta Adresi:", value: data.email),
            ProfileInfoRow(title: "Apartman / Site:", value: data.apartmentName),
            ProfileInfoRow(title: "Blok:", value: data.blockName),
            ProfileInfoRow(title: "Daire Numarası:", value: data.daireNo),
            ProfileInfoRow(title: "Kayıt Tarihi:", value: data.registirationDate)
        ]
        
        rows.forEach { infoStack.addArrangedSubview($0) }
    }

    private func showDeleteprofileAlert() {
        
        let alert = UIAlertController(title: "Hesabı Sil", message: "Lütfen şifrenizi giriniz.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Şifreniz"
            textField.borderStyle = .roundedRect
            textField.clearButtonMode = .whileEditing
            textField.isSecureTextEntry = true
            
        }
        
        // Cancel
        let cancel = UIAlertAction(title: "İptal", style: .cancel) { handler in
            print("iptal edildi")
        }

               // Confirm
        let confirm = UIAlertAction(title: "Tamam", style: .default) { handler in
            let text = alert.textFields?.first?.text
            print("siliniyor...")
            print("şifre : \(text ?? "")")
            
            guard let passwordText = text else { return }
            
            print("passwordText is : \(passwordText)")
            
            self.viewModel.deleteUserprofileRequest(with: passwordText)
            
            
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        present(alert, animated: true)
        
    }
    
}

extension UserProfileViewController: UserProfileVMOutputDelegate {
    
    func showSuccessDelete() {
        presentAlert(
            title: "Başarılı!",
            message: "Hesabınız başarıyla silindi.",
            actions: [
                (title: "Tamam", style: .cancel, handler: {
                    print("tamam seçildi")
                    self.logOut()
                    
                })
            ]
        )
    }
    
    func fetchUserDocs(with displayedSections: displayedSections) {
        self.displayedSections = displayedSections
        DispatchQueue.main.async {
            self.docsTableView.reloadData()
            
        }
        
    }
    
    func showError(with title: String, and error: String) {
        DispatchQueue.main.async {
            Utils.shared.showAutoDismissAlert(title: title, message: error, duration: 3.0, viewController: self)
        }
        
    }
    
    func updateUserProfile(userProfile: UserProfile) {
        self.setupProfileInfo(data: userProfile)
        
    }

}

extension UserProfileViewController {
    
    func layout() {
        
      //  let safeArea = self.view.safeAreaLayoutGuide
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // Header
        contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        // Profile Card
        contentView.addSubview(profileCard)
        profileCard.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        profileCard.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        profileCard.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        profileCard.addSubview(roleLabel)
        roleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(70)
        }
        
        profileCard.addSubview(infoStack)
        infoStack.axis = .vertical
        infoStack.spacing = 8

        infoStack.snp.makeConstraints { make in
            make.top.equalTo(roleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        /*
        // Documents
        contentView.addSubview(documentsView)
        documentsView.snp.makeConstraints { make in
            make.top.equalTo(profileCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }*/
        
        dangerView.addSubview(dangerHeader)
        dangerHeader.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        dangerView.addSubview(dangerText)
        dangerText.snp.makeConstraints { make in
            make.top.equalTo(dangerHeader.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        dangerView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(dangerText.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.width.equalTo(140)
        }
        
        documentsView.addSubview(docsTableView)
        docsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        
        // 1) StackView oluştur
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        // 2) ContentView’e ekle
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(32)
        }

        // 3) StackView içine alt alta view’leri koy
        stackView.addArrangedSubview(profileCard)
        stackView.addArrangedSubview(documentsView)
        stackView.addArrangedSubview(dangerView)
        
        
        
    }
    
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = displayedSections?.documents.count else { return 0 }
        guard let isExpanded = displayedSections?.isExpanded else { return 0 }
        
        return isExpanded ? count : 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentsTableviewCell.identifier, for: indexPath) as? DocumentsTableviewCell
        
        else {
            return UITableViewCell()
        }
        
        if let doc = displayedSections?.documents[indexPath.row]  {
            cell.configure(with: doc )
        }
        
        return cell
        
    }
    
    // MARK: - Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        header.backgroundColor = .white
        header.layer.cornerRadius = 8

        let sectionTitle = UILabel(frame: CGRect(x: 16, y: 15, width: tableView.bounds.width-32, height: 20))
        sectionTitle.textColor = .black
        sectionTitle.font = .boldSystemFont(ofSize: 16)
        sectionTitle.text = displayedSections?.sectionName

        header.addSubview(sectionTitle)

        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
         header.addGestureRecognizer(tap)
         header.tag = section // hangi section olduğunu bilmek için
         
        return header
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        else {
            return 0
        }
        
    }
    
    @objc private func headerTapped(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        print("Header \(section) tapped")
        displayedSections?.isExpanded.toggle()
        docsTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        
        // burada section’a göre işlemini yap
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let fileurl = displayedSections?.documents[indexPath.row].filename
        let vc = ShowDocumentVC()
        vc.invoiceUrl = fileurl
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
