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
    init(view: VideoViewProtocol, router: RouterProtocol, videoID: String)
    func goToPreviousScreen()
    func playerURRequestL() -> URLRequest?
    func playerURL() -> URL?
}

final class VideoPresenter: VideoViewPresenterProtocol {
    weak var view: VideoViewProtocol?
    var router: RouterProtocol?
    let videoID: String
    
    init(view: VideoViewProtocol, router: RouterProtocol, videoID: String) {
        self.view = view
        self.router = router
        self.videoID = videoID
    }
    
    func playerURRequestL() -> URLRequest? {
        guard let url = playerURL() else {return nil}
        print(url.absoluteString)
        
        return URLRequest(url: url)
    }
    
    func playerURL() -> URL? {
        guard let video = DataManager.shared.video(forKey: videoID) else {return nil}
        
        return URL(string: video.playerURLString)
    }
    
    func goToPreviousScreen() {
        router?.popToPreviousViewController()
    }
}
