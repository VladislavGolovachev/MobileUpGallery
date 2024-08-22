//
//  AuthViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 20.08.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    var presenter: AuthViewPresenterProtocol?
    
    lazy var appNameLabel: UILabel = {
        let label = PaddingLabel(topInset: 10, leftInset: 24, bottomInset: 10, rightInset: 24)
        label.text = "Mobile Up\nGallery"
        label.textColor = .black
        label.font = .systemFont(ofSize: 44, weight: .bold)
        label.numberOfLines = 2
        
        return label
    }()
    lazy var authButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = 12
        button.backgroundColor = .black
        
        button.setTitle("Вход через VK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        if let label = button.titleLabel {
            label.font = .systemFont(ofSize: 15, weight: .medium)
        }
        button.addTarget(self, action: #selector(authButtonAction(_:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(authButton)
        view.addSubview(appNameLabel)
        
        setupConstraints()
    }
}

//MARK: Private functions
extension AuthViewController {
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        authButton.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            appNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            appNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            authButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            authButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            authButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}

//MARK: Actions
extension AuthViewController {
    @objc func authButtonAction(_ sender: UIButton) {
        presenter?.showLoginWebPage()
    }
}

//MARK: AuthViewProtocol
extension AuthViewController: AuthViewProtocol {
    
}
