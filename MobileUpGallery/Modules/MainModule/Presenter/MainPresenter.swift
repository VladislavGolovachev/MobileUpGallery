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
    
}

final class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
}
