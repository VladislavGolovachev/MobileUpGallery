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
    init(view: AuthViewProtocol, router: RouterProtocol)
    func showLoginWebPage()
}

final class AuthPresenter: AuthViewPresenterProtocol {
    weak var view: AuthViewProtocol?
    var router: RouterProtocol?
    
    init(view: AuthViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func showLoginWebPage() {
        router?.goToMainViewController()
//        router?.showWebViewController()
    }
}
