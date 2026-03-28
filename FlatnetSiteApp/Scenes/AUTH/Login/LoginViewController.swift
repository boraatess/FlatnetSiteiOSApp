//
//  LoginViewController.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import UIKit
import SnapKit
import Combine
import SVProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let header = HeaderView(
           icon: UIImage(named: "inputNew"),
           title: "Giriş Yap",
           subtitle: "Devam etmek için lütfen giriş yapın."
       )
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Giriş Yap"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Devam etmek için lütfen giriş yapın."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-Posta"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "ornek@gmail.com"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifre"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    /*
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "********"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        return tf
    }()
    */
    
    private let passwordTextField: PasswordTextField = {
        let tf = PasswordTextField()
        tf.placeholder = "********"
        return tf
    }()
    
    
    private let forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Şifremi unuttum.", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Giriş Yap", for: .normal)
        btn.backgroundColor = UIColor.systemIndigo
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.isUserInteractionEnabled = true
        
        return btn
    }()
    
    private let signupLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesabınız yok mu?"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let signupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Hemen Kayıt Olun", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    
    var cancellables = Set<AnyCancellable>()

    let viewModel = LoginViewModel()

    // MARK: - Lifecycle    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        viewModel.outputDelegate = self
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonclick), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupButtonclick), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonclicked), for: .touchUpInside)
        
        bindViewModel()
        
    }
    
    private func bindViewModel() {
        // ✅ TextField → ViewModel
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        
        /*
        // ✅ ViewModel → Button enable/disable
        viewModel.isLoginEnabled
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        */
    }
       
    @objc private func emailChanged() {
        viewModel.email = emailTextField.text ?? ""
    }
       
    @objc private func passwordChanged() {
        viewModel.password = passwordTextField.text ?? ""
    }
    
    @objc func forgotPasswordButtonclick() {
        print("forgot pass clicked...")
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func signupButtonclick () {
        print("sign up clicked...")
        let vc = SignupViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginButtonclicked () {

        print("login button clicked...")
        SVProgressHUD.show(withStatus: "Giriş Yapılıyor...")

        self.viewModel.sendLoginRequest()
        
    }
    
    // MARK: - Layout with SnapKit
    
    private func setupLayout() {
        
        view.backgroundColor = AppColors.shared.vcBgColor
        
        /*
        // Üst başlıklar
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }*/
        
        
        view.addSubview(header)
              
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        header.setBackgroundColor(AppColors.shared.vcBgColor)
        
        
        // Container
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        // Form elemanları
        container.addSubview(emailLabel)
        container.addSubview(emailTextField)
        container.addSubview(passwordLabel)
        container.addSubview(passwordTextField)
        container.addSubview(forgotPasswordButton)
        container.addSubview(loginButton)
        
        let signupStack = UIStackView(arrangedSubviews: [signupLabel, signupButton])
        signupStack.axis = .horizontal
        signupStack.spacing = 4
        container.addSubview(signupStack)
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.left.equalTo(emailTextField)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(6)
            make.left.right.height.equalTo(emailTextField)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(6)
            make.right.equalTo(passwordTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        signupStack.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
    }
    
}

extension LoginViewController: LoginViewModelOutputProtocol {
    
    func goTabbar() {
        
        print("tabbar screen openning...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let vc = TabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
                
        
    }
    
    func showError(message: String) {
        print("Error! \(message)")
        
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            Utils.shared.showAutoDismissAlert(title: title, message: message, duration: 5.0, viewController: self)
            
        }
  
    }
    
}
