//
//  AuthPresenter.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import Foundation

protocol AuthViewProtocol: AnyObject {
    
}

protocol AuthViewPresenterProtocol: AnyObject {
    
}

final class AuthPresenter: AuthViewPresenterProtocol {
    weak var view: AuthViewProtocol?
}
