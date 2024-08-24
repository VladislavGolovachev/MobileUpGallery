//
//  WebPresenter.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 23.08.2024.
//

import Foundation

protocol WebViewProtocol: AnyObject {
    
}

protocol WebViewPresenterProtocol: AnyObject {
    init(view: WebViewProtocol, router: RouterProtocol)
    func extractAccessToken(by response: URLResponse) -> Bool
    func showMainScreen()
}

final class WebPresenter: WebViewPresenterProtocol {
    weak var view: WebViewProtocol?
    var router: RouterProtocol?
    
    init(view: WebViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func showMainScreen() {
        router?.goToMainViewController()
    }
    
    func extractAccessToken(by response: URLResponse) -> Bool {
        guard let url = response.url,
              let fragment = URLComponents(url: url, resolvingAgainstBaseURL: true)?.fragment else {return false}
        
        var urlComponents = URLComponents()
        urlComponents.query = fragment
        guard let queryItems = urlComponents.queryItems else {return false}
        
        for queryItem in queryItems {
            if queryItem.name == AccessToken.key {
                guard let tokenString = queryItem.value else {return false}
                
                let token = AccessToken(token: tokenString, creationDate: Date.now)
                DataManager.shared.updateToken(with: token, forKey: AccessToken.key)
                
                return true
            }
        }
        return false
    }
}
