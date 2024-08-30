//
//  AuthViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 20.08.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    var presenter: AuthViewPresenterProtocol?
    
    let appNameLabel: UILabel = {
        let label = PaddingLabel(topInset: Constants.Padding.top,
                                 leftInset: Constants.Padding.left,
                                 bottomInset: Constants.Padding.bottom,
                                 rightInset: Constants.Padding.right)
        label.text = "Mobile Up\nGallery"
        label.textColor = .black
        label.font = Constants.Font.label
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
            label.font = Constants.Font.button
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
            appNameLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                              constant: Constants.Constraints.Label.topConstant),
            appNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            appNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            authButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                               constant: Constants.Constraints.Button.bottomConstant),
            authButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, 
                                                constant: Constants.Constraints.Button.leadingConstant),
            authButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                 constant: Constants.Constraints.Button.trailingConstant),
            authButton.heightAnchor.constraint(equalToConstant: Constants.Constraints.Button.heightConstant)
        ])
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        self.present(alert, animated: true)
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

//MARK: ViewConstants
extension AuthViewController {
    enum Constants {
        enum Padding {
            static let left = 24.0
            static let right = 24.0
            static let bottom = 10.0
            static let top = 10.0
        }
        enum Constraints {
            enum Label {
                static let topConstant = 160.0
            }
            enum Button {
                static let bottomConstant = -8.0
                static let heightConstant = 52.0
                static let leadingConstant = 16.0
                static let trailingConstant = -16.0
            }
        }
        enum Font {
            static let label = UIFont.systemFont(ofSize: 44, weight: .bold)
            static let button = UIFont.systemFont(ofSize: 15, weight: .medium)
        }
    }
}
