//
//  ModuleBuilder.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

protocol ModuleBuilderProtocol {
    func createAuthModule(router: RouterProtocol) -> UIViewController
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createPhotoModule(router: RouterProtocol) -> UIViewController
    func createVideoModule(router: RouterProtocol) -> UIViewController
}

final class ModuleBuilder: ModuleBuilderProtocol {
    func createAuthModule(router: RouterProtocol) -> UIViewController {
        let vc = AuthViewController()
        let presenter = AuthPresenter(view: vc, router: router)
        vc.presenter = presenter
        
        return vc
    }
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let vc = MainViewController()
        let presenter = MainPresenter(view: vc, router: router)
        vc.presenter = presenter
        
        return vc
    }
    
    func createPhotoModule(router: RouterProtocol) -> UIViewController {
        let vc = PhotoViewController()
        let presenter = PhotoPresenter(view: vc, router: router)
        vc.presenter = presenter
        
        return vc
    }
    
    func createVideoModule(router: RouterProtocol) -> UIViewController {
        let vc = VideoViewController()
        let presenter = VideoPresenter(view: vc, router: router)
        vc.presenter = presenter
        
        return vc
    }
}
