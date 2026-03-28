//
//  ForgotPasswordViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import Foundation
import UIKit
import SnapKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "key.fill") // SF Symbol
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifre Sıfırlama"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kayıtlı e-posta adresinizi girerek\nsıfırlama linki talep edin."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-posta Adresiniz"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "e-posta@adresiniz.com"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let resetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sıfırlama Linki Gönder", for: .normal)
        btn.backgroundColor = UIColor.systemIndigo
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let backToLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Giriş ekranına geri dön", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    
    let viewModel = ForgotPasswordVM()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        backToLoginButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        bindViewModel()
        
        viewModel.outputDelegate = self
    }
    
    @objc func resetButtonTapped() {
        
        viewModel.sendPasswordResetEmail()
        
        
    }
    
    @objc func goBack() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func bindViewModel() {
        
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        
        
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailTextField.text ?? ""
    }
    
    
    // MARK: - Layout with SnapKit
    
    private func setupLayout() {

        view.backgroundColor = AppColors.shared.vcBgColor
        
        // Container
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        // Başlık stack (ikon + title)
        let headerStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        
        container.addSubview(headerStack)
        container.addSubview(subtitleLabel)
        container.addSubview(emailLabel)
        container.addSubview(emailTextField)
        container.addSubview(resetButton)
        container.addSubview(backToLoginButton)
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        headerStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerStack.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        backToLoginButton.snp.makeConstraints { make in
            make.top.equalTo(resetButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension ForgotPasswordViewController: ForgotPasswordOutputDelegate {
   
    func showAlert(with title: String, and message: String) {
        DispatchQueue.main.async {
            Utils.shared.showAutoDismissAlert(title: title, message: message, duration: 2.0, viewController: self)
        }
     
        
    }
    
    
    func showErrorMessage(_ message: String) {
        
        DispatchQueue.main.async {
            Utils.shared.showAutoDismissAlert(title: "", message: message, duration: 2.0, viewController: self)
            
            
        }
       
    }
  
    
    
}
