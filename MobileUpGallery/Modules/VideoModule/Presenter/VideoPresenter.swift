//
//  VideoPresenter.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import Foundation

protocol VideoViewProtocol: AnyObject {
    
}

protocol VideoViewPresenterProtocol: AnyObject {
    init(view: VideoViewProtocol, router: RouterProtocol)
    func goToPreviousScreen()
}

final class VideoPresenter: VideoViewPresenterProtocol {
    weak var view: VideoViewProtocol?
    var router: RouterProtocol?
    
    init(view: VideoViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func goToPreviousScreen() {
        router?.popToPreviousViewController()
    }
}
