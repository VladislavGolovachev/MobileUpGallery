//
//  Router.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

protocol RouterProtocol {
    init(moduleBuilder: ModuleBuilderProtocol)
    func showWebViewController()
    func goToMainViewController()
    func goToPhotoViewController()
    func goToVideoViewController()
    func popToPreviousViewController()
}

final class Router: RouterProtocol {
    var moduleBuilder: ModuleBuilderProtocol
    lazy var rootViewController: UIViewController = {
        return moduleBuilder.createAuthModule(router: self)
    }()
    var navigationController: UINavigationController? {
        return rootViewController.presentedViewController as? UINavigationController
    }
    
    init(moduleBuilder: ModuleBuilderProtocol) {
        self.moduleBuilder = moduleBuilder
    }
    
    func showWebViewController() {
        let webVC = moduleBuilder.createWebModule(router: self)
        rootViewController.present(webVC, animated: true)
    }
    
    func goToMainViewController() {
        let mainVC = moduleBuilder.createMainModule(router: self)
        let navVC = UINavigationController(rootViewController: mainVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .coverVertical
        rootViewController.present(navVC, animated: true)
    }
    
    func goToPhotoViewController() {
        let photoVC = moduleBuilder.createPhotoModule(router: self)
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    func goToVideoViewController() {
        let videoVC = moduleBuilder.createVideoModule(router: self)
        navigationController?.pushViewController(videoVC, animated: true)
    }
    
    func popToPreviousViewController() {
        if let count = navigationController?.viewControllers.count, count == 1 {
            navigationController?.dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
