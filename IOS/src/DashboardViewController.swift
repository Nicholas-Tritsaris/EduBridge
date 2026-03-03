// iOS/src/DashboardViewController.swift
import UIKit

class DashboardViewController: UIViewController {
    
    private let user: UserData
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let welcomeLabel = UILabel()
    private let emailLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    
    // MARK: - Init
    
    init(user: UserData) {
        self.user = user
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
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Header
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        
        welcomeLabel.text = "Welcome! 👋"
        welcomeLabel.font = .systemFont(ofSize: 24, weight: .bold)
        welcomeLabel.textColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(welcomeLabel)
        
        emailLabel.text = user.email
        emailLabel.font = .systemFont(ofSize: 14, weight: .regular)
        emailLabel.textColor = .gray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(emailLabel)
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        logoutButton.tintColor = .white
        logoutButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        logoutButton.layer.cornerRadius = 6
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(logoutButton)
        
        // Features Section
        let featuresSection = createSection(title: "Available Features")
        contentView.addSubview(featuresSection)
        
        let featureGrid = UIView()
        featureGrid.translatesAutoresizingMaskIntoConstraints = false
        featuresSection.addSubview(featureGrid)
        
        // Feature Cards
        let features = [
            ("📚", "Classrooms", "Create classrooms"),
            ("📝", "Assignments", "Create tasks"),
            ("💬", "Messaging", "Communicate"),
            ("📊", "Analytics", "Track progress"),
        ]
        
        var previousCard: UIView?
        for (icon, title, desc) in features {
            let card = createFeatureCard(icon: icon, title: title, description: desc)
            featureGrid.addSubview(card)
            
            if let previous = previousCard {
                NSLayoutConstraint.activate([
                    card.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 12),
                ])
            } else {
                NSLayoutConstraint.activate([
                    card.topAnchor.constraint(equalTo: featureGrid.topAnchor),
                ])
            }
            
            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: featureGrid.leadingAnchor),
                card.trailingAnchor.constraint(equalTo: featureGrid.trailingAnchor),
                card.heightAnchor.constraint(equalToConstant: 80),
            ])
            
            previousCard = card
        }
        
        if let last = previousCard {
            NSLayoutConstraint.activate([
                last.bottomAnchor.constraint(equalTo: featureGrid.bottomAnchor),
            ])
        }
        
        setupConstraints(headerView: headerView, featuresSection: featuresSection)
    }
    
    private func setupConstraints(headerView: UIView, featuresSection: UIView) {
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
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            welcomeLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            emailLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            logoutButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: welcomeLabel.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 100),
            logoutButton.heightAnchor.constraint(equalToConstant: 36),
            
            featuresSection.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            featuresSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            featuresSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            featuresSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func createSection(title: String) -> UIView {
        let section = UIView()
        section.backgroundColor = .white
        section.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        section.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: section.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -20),
        ])
        
        return section
    }
    
    private func createFeatureCard(icon: String, title: String, description: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        card.layer.cornerRadius = 8
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = .systemFont(ofSize: 32)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(iconLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.4, green: 0.49, blue: 0.93, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descLabel.textColor = .gray
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(descLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            descLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
        ])
        
        return card
    }
    
    // MARK: - Actions
    
    @objc private func handleLogout() {
        navigationController?.popToRootViewController(animated: true)
    }
}
