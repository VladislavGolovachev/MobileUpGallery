//
//  WebViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var presenter: WebViewPresenterProtocol?
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        setupConstraints()
        
        guard let urlRequest = NetworkService.shared.authRequest() else {return}
        webView.load(urlRequest)
    }
}

//MARK: Private functions
extension WebViewController {
    private func setupConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, 
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let result = presenter?.extractAccessToken(by: navigationResponse.response) else {return}
    
        if result {
            presenter?.showMainScreen()
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

//MARK: WebViewPresenterProtocol
extension WebViewController: WebViewProtocol {
    
}
