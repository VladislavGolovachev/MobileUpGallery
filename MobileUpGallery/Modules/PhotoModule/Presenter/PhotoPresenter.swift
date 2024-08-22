//
//  PhotoPresenter.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import Foundation

protocol PhotoViewProtocol: AnyObject {
    
}

protocol PhotoViewPresenterProtocol: AnyObject {
    init(view: PhotoViewProtocol, router: RouterProtocol)
    func goToPreviousScreen()
}

final class PhotoPresenter: PhotoViewPresenterProtocol {
    weak var view: PhotoViewProtocol?
    var router: RouterProtocol?
    
    init(view: PhotoViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func goToPreviousScreen() {
        router?.popToPreviousViewController()
    }
}
