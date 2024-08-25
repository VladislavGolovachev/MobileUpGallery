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
    func title() -> String?
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
        return URLRequest(url: url)
    }
    
    func playerURL() -> URL? {
        guard let video = DataManager.shared.video(forKey: videoID) else {return nil}
        return URL(string: video.playerURLString)
    }
    
    func title() -> String? {
        let title = DataManager.shared.video(forKey: videoID)?.title
        return title
    }
    
    func goToPreviousScreen() {
        router?.popToPreviousViewController()
    }
}
