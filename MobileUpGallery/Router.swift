//
//  Router.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

protocol RouterProtocol {
    init(moduleBuilder: ModuleBuilderProtocol)
    
    func initiateNavigationViewController() -> UIViewController
    func initiateAuthViewController(_ alertMessage: String?) -> UIViewController
    
    func showWebViewController()
    func goToMainViewController()
    func goToPhotoViewController(photoID: String)
    func goToVideoViewController(videoID: String)
    
    func popToPreviousViewController()
    func popToAuthViewController()
    func dismissWebViewController()
}

final class Router: RouterProtocol {
    private var moduleBuilder: ModuleBuilderProtocol
    private var authViewController: UIViewController?
    private var navigationController: UINavigationController?
    
    init(moduleBuilder: ModuleBuilderProtocol) {
        self.moduleBuilder = moduleBuilder
    }
    
    func initiateAuthViewController(_ alertMessage: String? = nil) -> UIViewController {
        let authVC = moduleBuilder.createAuthModule(router: self, alertMessage)
        authViewController = authVC
        
        return authVC
    }
    
    func initiateNavigationViewController() -> UIViewController {
        let mainVC = moduleBuilder.createMainModule(router: self)
        let navVC = UINavigationController(rootViewController: mainVC)
        navigationController = navVC
        
        return navVC
    }
    
    func showWebViewController() {
        let webVC = moduleBuilder.createWebModule(router: self)
        authViewController?.present(webVC, animated: true)
    }
    
    func goToMainViewController() {
        let navVC = initiateNavigationViewController()
        guard let authVC = authViewController, let window = authVC.view.window else {return}
        window.rootViewController = navVC
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            self.authViewController = nil
        }
    }
    
    func goToPhotoViewController(photoID: String) {
        let photoVC = moduleBuilder.createPhotoModule(router: self, photoID: photoID)
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    func goToVideoViewController(videoID: String) {
        let videoVC = moduleBuilder.createVideoModule(router: self, videoID: videoID)
        navigationController?.pushViewController(videoVC, animated: true)
    }
    
    func popToPreviousViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToAuthViewController() {
        let authVC = initiateAuthViewController()
        guard let navVC = navigationController, let window = navVC.view.window else {return}
        window.rootViewController = authVC
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            self.navigationController = nil
        }
    }
    
    func dismissWebViewController() {
        authViewController?.dismiss(animated: true)
    }
}
