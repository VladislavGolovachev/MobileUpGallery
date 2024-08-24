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
    func extractAccessToken(by response: URLResponse)
}

final class WebPresenter: WebViewPresenterProtocol {
    weak var view: WebViewProtocol?
    var router: RouterProtocol?
    
    init(view: WebViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func extractAccessToken(by response: URLResponse) {
        guard let url = response.url,
              let fragment = URLComponents(url: url, resolvingAgainstBaseURL: true)?.fragment else {return}
        
        var urlComponents = URLComponents()
        urlComponents.query = fragment
        guard let queryItems = urlComponents.queryItems else {return}
        
        for queryItem in queryItems {
            if let value = queryItem.value {
                print(queryItem.name, value)
                if queryItem.name == "access_token" {
                    print(VKURL.getAPIURL(for: .photos, with: (accessToken: value, count: "20", offset: "0"))!.absoluteString)
                }
            }
        }
    }
}
