// iOS/src/LoginViewController.swift
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    
    private let loginButton = UIButton(type: .system)
    private let signupButton = UIButton(type: .system)
    
    private let statusLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = "Welcome Back"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "Sign in to EduBridge"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Email Label
        emailLabel.text = "Email Address"
        emailLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        emailLabel.textColor = .darkGray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailLabel)
        
        // Email TextField
        emailTextField.placeholder = "your@email.com"
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0).cgColor
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailTextField)
        
        // Password Label
        passwordLabel.text = "Password"
        passwordLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        passwordLabel.textColor = .darkGray
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordLabel)
        
        // Password TextField
        passwordTextField.placeholder = "••••••••"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0).cgColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordTextField)
        
        // Login Button
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        loginButton.tintColor = .white
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        loginButton.layer.cornerRadius = 6
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loginButton)
        
        // Signup Button
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = .clear
        signupButton.tintColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        signupButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        signupButton.layer.cornerRadius = 6
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signupButton)
        
        // Status Label
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 14, weight: .regular)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusLabel)
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        
        // Constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        // ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // ContentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
        ])
        
        // Title
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        // Subtitle
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        // Email Label
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
        
        // Email TextField
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Password Label
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
        
        // Password TextField
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Login Button
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Signup Button
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            signupButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Status Label
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func handleLogin() {
        guard let email = emailTextField.text, !email.isEmpty else {
            statusLabel.text = "Please enter email"
            statusLabel.textColor = .red
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            statusLabel.text = "Please enter password"
            statusLabel.textColor = .red
            return
        }
        
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        signupButton.isEnabled = false
        
        ApiClient.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.loginButton.isEnabled = true
                self?.signupButton.isEnabled = true
                
                switch result {
                case .success(let response):
                    if response.success {
                        self?.statusLabel.text = "Login successful!"
                        self?.statusLabel.textColor = .green
                        // Navigate to dashboard
                        if let user = response.user {
                            self?.navigateToDashboard(user: user)
                        }
                    } else {
                        self?.statusLabel.text = response.message
                        self?.statusLabel.textColor = .red
                    }
                case .failure(let error):
                    self?.statusLabel.text = "Network error: \(error)"
                    self?.statusLabel.textColor = .red
                }
            }
        }
    }
    
    @objc private func handleSignup() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    private func navigateToDashboard(user: UserData) {
        let dashboardVC = DashboardViewController(user: user)
        navigationController?.pushViewController(dashboardVC, animated: true)
    }
}
