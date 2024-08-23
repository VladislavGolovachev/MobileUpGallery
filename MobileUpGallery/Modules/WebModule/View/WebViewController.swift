//
//  WebViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: """
                         https://oauth.vk.com/authorize?\
                         client_id=51793431&\
                         display=mobile&\
                         redirect_uri=https://oauth.vk.com/blank.html&\
                         scope=20&\
                         response_type=token&\
                         v=5.199
                         """) {
            webView.load(URLRequest(url: url))
        }
        webView.navigationDelegate = self
    
//    https://mobileupgallerytest.ru/auth#
//        access_token=vk1.a&
//        expires_in=86400&
//        user_id=234488898
        view.addSubview(webView)
        setupConstraints()
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

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, 
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
        let fragment = URLComponents(url: url, resolvingAgainstBaseURL: true)?.fragment else {
            decisionHandler(.allow)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.query = fragment
        guard let queryItems = urlComponents.queryItems else {return}
        
        for queryItem in queryItems {
            if let value = queryItem.value {
                print(queryItem.name, value)
            }
        }
        
        decisionHandler(.allow)
    }
}
