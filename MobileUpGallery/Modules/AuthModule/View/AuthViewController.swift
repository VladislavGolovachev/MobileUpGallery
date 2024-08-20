//
//  AuthViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 20.08.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    var presenter: AuthViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

extension AuthViewController: AuthViewProtocol {
    
}
