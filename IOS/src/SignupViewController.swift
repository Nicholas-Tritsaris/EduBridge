// iOS/src/SignupViewController.swift
import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    
    private let confirmPasswordLabel = UILabel()
    private let confirmPasswordTextField = UITextField()
    
    private let signupButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
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
        titleLabel.text = "Create Account"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "Join the learning revolution"
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
        passwordLabel.text = "Password (min 6 characters)"
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
        
        // Confirm Password Label
        confirmPasswordLabel.text = "Confirm Password"
        confirmPasswordLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        confirmPasswordLabel.textColor = .darkGray
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmPasswordLabel)
        
        // Confirm Password TextField
        confirmPasswordTextField.placeholder = "••••••••"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.layer.borderWidth = 2.0
        confirmPasswordTextField.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0).cgColor
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmPasswordTextField)
        
        // Signup Button
        signupButton.setTitle("Create Account", for: .normal)
        signupButton.backgroundColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        signupButton.tintColor = .white
        signupButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        signupButton.layer.cornerRadius = 6
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signupButton)
        
        // Back Button
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = .clear
        backButton.tintColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        backButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        backButton.layer.cornerRadius = 6
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backButton)
        
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        // Subtitle
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        // Email Label
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
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
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
        
        // Password TextField
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Confirm Password Label
        NSLayoutConstraint.activate([
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
        
        // Confirm Password TextField
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 8),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Signup Button
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            signupButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Back Button
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func handleSignup() {
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
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            statusLabel.text = "Please confirm password"
            statusLabel.textColor = .red
            return
        }
        
        if password != confirmPassword {
            statusLabel.text = "Passwords do not match"
            statusLabel.textColor = .red
            return
        }
        
        if password.count < 6 {
            statusLabel.text = "Password must be at least 6 characters"
            statusLabel.textColor = .red
            return
        }
        
        activityIndicator.startAnimating()
        signupButton.isEnabled = false
        backButton.isEnabled = false
        
        ApiClient.shared.signup(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.signupButton.isEnabled = true
                self?.backButton.isEnabled = true
                
                switch result {
                case .success(let response):
                    if response.success {
                        self?.statusLabel.text = "Account created! Check email for verification code."
                        self?.statusLabel.textColor = .green
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            let verificationVC = EmailVerificationViewController(email: email)
                            self?.navigationController?.pushViewController(verificationVC, animated: true)
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
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
