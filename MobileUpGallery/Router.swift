//
//  Router.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

protocol RouterProtocol {
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol)
    func initiateRootViewController()
    func showWebViewController()
    func goToMainViewController()
    func goToPhotoViewController()
    func goToVideoViewController()
    func popToRootViewController()
    func popToPreviousViewController()
}

final class Router: RouterProtocol {
    var navigationController: UINavigationController
    var moduleBuilder: ModuleBuilderProtocol
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
    func initiateRootViewController() {
        let authVC = moduleBuilder.createAuthModule(router: self)
        navigationController.viewControllers = [authVC]
    }
    
    func showWebViewController() {
        let webVC = WebViewController()
        navigationController.viewControllers.first?.present(webVC, animated: true)
    }
    
    func goToMainViewController() {
        let mainVC = moduleBuilder.createMainModule(router: self)
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    func goToPhotoViewController() {
        let photoVC = moduleBuilder.createPhotoModule(router: self)
        navigationController.pushViewController(photoVC, animated: true)
    }
    
    func goToVideoViewController() {
        let videoVC = moduleBuilder.createVideoModule(router: self)
        navigationController.pushViewController(videoVC, animated: true)
    }
    
    func popToRootViewController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func popToPreviousViewController() {
        navigationController.popViewController(animated: true)
    }
}
