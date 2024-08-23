//
//  MainPresenter.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: RouterProtocol)
    func returnToAuthScreen()
    func showPhotoScreen()
    func showVideoScreen()
}

final class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    
    init(view: MainViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func returnToAuthScreen() {
        router?.popToPreviousViewController()
    }
    
    func showPhotoScreen() {
        router?.goToPhotoViewController()
    }
    
    func showVideoScreen() {
        router?.goToVideoViewController()
    }
}
