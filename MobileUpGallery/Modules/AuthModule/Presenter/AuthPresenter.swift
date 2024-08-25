//
//  AuthPresenter.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import Foundation

protocol AuthViewProtocol: AnyObject {
}

protocol AuthViewPresenterProtocol: AnyObject {
    init(view: AuthViewProtocol, router: RouterProtocol, message: String?)
    func showLoginWebPage()
    func needsToShow() -> (Bool, String)
}

final class AuthPresenter: AuthViewPresenterProtocol {
    weak var view: AuthViewProtocol?
    var router: RouterProtocol?
    var message: String?
    
    init(view: AuthViewProtocol, router: RouterProtocol, message: String? = nil) {
        self.view = view
        self.router = router
        self.message = message
    }
    
    func showLoginWebPage() {
        router?.showWebViewController()
    }
    
    func needsToShow() -> (Bool, String) {
        if let message {
            return (true, message)
        }
        return (false, "")
    }
}
