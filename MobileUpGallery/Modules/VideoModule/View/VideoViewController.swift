//
//  VideoViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit
import WebKit

final class VideoViewController: UIViewController {

    var presenter: VideoViewPresenterProtocol?
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        webView.backgroundColor = .blue
        
        webView.load(URLRequest(url: URL(string: "https://www.youtube.com/watch?v=M-OdGpeAqQQ")!))
        
        customizeNavigationBar()
        view.addSubview(webView)
        setupConstraints()
    }
}

//MARK: Private Functions
extension VideoViewController {
    private func customizeNavigationBar() {
        navigationItem.title = "Голубой огонек в MobileUp"

        let config = UIImage.SymbolConfiguration(weight: .semibold)
        let backButtonImage = UIImage(systemName: "chevron.left", withConfiguration: config)
        let shareButtonImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: shareButtonImage,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(shareButtonAction(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage,
                                                            style: .done,
                                                            target: self,
                                                           action: #selector(backButtonAction(_:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
    }
}

//MARK: Actions
extension VideoViewController {
    @objc func shareButtonAction(_ sender: UIBarButtonItem) {
        print("share")
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        presenter?.goToPreviousScreen()
    }
}

//MARK: VideoViewProtocol
extension VideoViewController: VideoViewProtocol {
    
}
