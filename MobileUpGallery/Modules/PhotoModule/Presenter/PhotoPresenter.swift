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
    
}

final class PhotoPresenter: PhotoViewPresenterProtocol {
    weak var view: PhotoViewProtocol?
}
