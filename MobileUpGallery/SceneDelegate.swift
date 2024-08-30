//
//  SceneDelegate.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 20.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {return}
        let window = UIWindow(windowScene: windowScene)
        let moduleBuilder = ModuleBuilder()
        let router = Router(moduleBuilder: moduleBuilder)
        var rootVC = UIViewController()
        
        var token: AccessToken?
        do {
            token = try DataManager.shared.token(forKey: AccessToken.key)
        } catch {}
        
        if let token, token.isValid {
            rootVC = router.initiateNavigationViewController()
        } else {
            rootVC = router.initiateAuthViewController()
        }
        
        window.rootViewController = rootVC
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

