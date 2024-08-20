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
    
}

final class VideoPresenter: VideoViewPresenterProtocol {
    weak var view: VideoViewProtocol?
}
