//
//  ModuleBuilder.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

protocol ModuleBuilderProtocol {
    func createAuthModule(router: RouterProtocol, _ message: String?) -> UIViewController
    func createWebModule(router: RouterProtocol) -> UIViewController
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createPhotoModule(router: RouterProtocol, photoID: String) -> UIViewController
    func createVideoModule(router: RouterProtocol, videoID: String) -> UIViewController
}

final class ModuleBuilder: ModuleBuilderProtocol {
    func createAuthModule(router: RouterProtocol, _ message: String? = nil) -> UIViewController {
        let vc = AuthViewController()
        let presenter = AuthPresenter(view: vc, router: router, message: message)
        vc.presenter = presenter
        
        return vc
    }
    
    func createWebModule(router: RouterProtocol) -> UIViewController {
        let vc = WebViewController()
        let presenter = WebPresenter(view: vc, router: router)
        vc.presenter = presenter
        
        return vc
    }
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let vc = MainViewController()
        let presenter = MainPresenter(view: vc, router: router)
        vc.presenter = presenter
        
        return vc
    }
    
    func createPhotoModule(router: RouterProtocol, photoID: String) -> UIViewController {
        let vc = PhotoViewController()
        let presenter = PhotoPresenter(view: vc, router: router, photoID: photoID)
        vc.presenter = presenter
        
        return vc
    }
    
    func createVideoModule(router: RouterProtocol, videoID: String) -> UIViewController {
        let vc = VideoViewController()
        let presenter = VideoPresenter(view: vc, router: router, videoID: videoID)
        vc.presenter = presenter
        
        return vc
    }
}
