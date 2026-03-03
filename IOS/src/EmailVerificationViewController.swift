// iOS/src/EmailVerificationViewController.swift
import UIKit

class EmailVerificationViewController: UIViewController {
    
    private let email: String
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let codeLabel = UILabel()
    private let codeTextField = UITextField()
    
    private let verifyButton = UIButton(type: .system)
    private let resendButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    private let statusLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Init
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        titleLabel.text = "Verify Email"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "We sent a verification code to\n\(email)"
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Code Label
        codeLabel.text = "Verification Code"
        codeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        codeLabel.textColor = .darkGray
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(codeLabel)
        
        // Code TextField
        codeTextField.placeholder = "Enter 6-character code"
        codeTextField.borderStyle = .roundedRect
        codeTextField.layer.borderWidth = 2.0
        codeTextField.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0).cgColor
        codeTextField.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        codeTextField.textAlignment = .center
        codeTextField.keyboardType = .default
        codeTextField.autocapitalizationType = .allCharacters
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(codeTextField)
        
        // Verify Button
        verifyButton.setTitle("Verify Email", for: .normal)
        verifyButton.backgroundColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        verifyButton.tintColor = .white
        verifyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        verifyButton.layer.cornerRadius = 6
        verifyButton.addTarget(self, action: #selector(handleVerify), for: .touchUpInside)
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verifyButton)
        
        // Resend Button
        resendButton.setTitle("Resend Code", for: .normal)
        resendButton.backgroundColor = .clear
        resendButton.tintColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        resendButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        resendButton.addTarget(self, action: #selector(handleResend), for: .touchUpInside)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(resendButton)
        
        // Back Button
        backButton.setTitle("Back to Sign Up", for: .normal)
        backButton.backgroundColor = .clear
        backButton.tintColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        backButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
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
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            codeLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            codeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            codeTextField.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 8),
            codeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            codeTextField.heightAnchor.constraint(equalToConstant: 48),
            
            verifyButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            verifyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            verifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            verifyButton.heightAnchor.constraint(equalToConstant: 44),
            
            resendButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            resendButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: resendButton.bottomAnchor, constant: 12),
            backButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func handleVerify() {
        guard let code = codeTextField.text, !code.isEmpty else {
            statusLabel.text = "Please enter verification code"
            statusLabel.textColor = .red
            return
        }
        
        activityIndicator.startAnimating()
        verifyButton.isEnabled = false
        resendButton.isEnabled = false
        
        ApiClient.shared.verifyEmail(email: email, code: code) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.verifyButton.isEnabled = true
                self?.resendButton.isEnabled = true
                
                switch result {
                case .success(let response):
                    if response.success {
                        self?.statusLabel.text = "Email verified successfully!"
                        self?.statusLabel.textColor = .green
                        if let user = response.user {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                let dashboardVC = DashboardViewController(user: user)
                                self?.navigationController?.pushViewController(dashboardVC, animated: true)
                            }
                        }
                    } else {
                        self?.statusLabel.text = response.message
                        self?.statusLabel.textColor = .red
                    }
                case .failure(let error):
                    self?.statusLabel.text = "Error: \(error)"
                    self?.statusLabel.textColor = .red
                }
            }
        }
    }
    
    @objc private func handleResend() {
        activityIndicator.startAnimating()
        
        ApiClient.shared.resendVerification(email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let response):
                    self?.statusLabel.text = response.message
                    self?.statusLabel.textColor = response.success ? .green : .red
                case .failure(let error):
                    self?.statusLabel.text = "Error: \(error)"
                    self?.statusLabel.textColor = .red
                }
            }
        }
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
