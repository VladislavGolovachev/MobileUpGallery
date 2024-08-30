//
//  MainPresenter.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func reloadList()
    func reloadItem(at row: Int)
    func showAlert(message: String)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: RouterProtocol)
    func showPhotoScreen(photoID: Int)
    func showVideoScreen(videoID: Int)
    func popToAuthScreen()
    
    func prefetchPhotos(for index: Int)
    func prefetchVideos(for Index: Int)
    func photo(at index: Int) -> UIImage?
    func video(at index: Int) -> UIImage?
    func videoTitle(at index: Int) -> String?
    
    var photosAmount: Int {get}
    var videosAmount: Int {get}
    func emptyPhotoCache()
    func emptyVideoCache()
    func stopDownloading()
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    
    private var queue = DispatchQueue(label: "vladislav-golovachev-serial-queue", qos: .utility)
    private var isDownloading = false
    private var photoMaxCount: Int?
    private var videoMaxCount: Int?
    
    
    init(view: MainViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}

extension MainPresenter: MainViewPresenterProtocol {
    var photosAmount: Int {
        DataManager.shared.photosAmount
    }
    
    var videosAmount: Int {
        DataManager.shared.videosAmount
    }
    
    func emptyPhotoCache() {
        DataManager.shared.emptyPhotoCache()
    }
    
    func emptyVideoCache() {
        DataManager.shared.emptyVideoCache()
    }
    
    func stopDownloading() {
        URLSession.shared.cancelAllTasks()
        isDownloading = false
    }
    
    func prefetchPhotos(for index: Int) {
        queue.async {
            if let photoMaxCount = self.photoMaxCount {
                if photoMaxCount <= index {
                    return
                }
            }
            if self.isDownloading {
                return
            }
            
            let photo = DataManager.shared.photo(forKey: String(index))
            if photo == nil {
                self.isDownloading = true
                self.getPhotos(offset: index)
            }
        }
    }
    
    func prefetchVideos(for index: Int) {
        queue.async {
            if let videoMaxCount = self.videoMaxCount {
                if videoMaxCount <= index {
                    return
                }
            }
            if self.isDownloading {
                return
            }
            
            let video = DataManager.shared.video(forKey: String(index))
            if video == nil {
                self.isDownloading = true
                self.getVideos(offset: index)
            }
        }
    }
    
    func photo(at index: Int) -> UIImage? {
        let photoInstance = DataManager.shared.photo(forKey: String(index))
        return compressedImage(data: photoInstance?.data)
    }
    
    func video(at index: Int) -> UIImage? {
        let videoInstance = DataManager.shared.video(forKey: String(index))
        return compressedImage(data: videoInstance?.preview)
    }
    
    func videoTitle(at index: Int) -> String? {
        let videoInstance = DataManager.shared.video(forKey: String(index))
        return videoInstance?.title
    }
    
    func showPhotoScreen(photoID: Int) {
        router?.goToPhotoViewController(photoID: String(photoID))
    }
    
    func showVideoScreen(videoID: Int) {
        router?.goToVideoViewController(videoID: String(videoID))
    }
    
    func popToAuthScreen() {
        do {
            try DataManager.shared.removeToken(forKey: AccessToken.key)
        } catch {
            handleError(error)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.router?.popToAuthViewController()
            }
            return
        }
        router?.popToAuthViewController()
    }
}

//MARK: Private Functions
extension MainPresenter {
    private func getPhotos(offset: Int) {
        guard let tokenString = getTokenString() else {return}
        let details = (accessToken: tokenString, offset: String(offset))
        
        NetworkService.shared.getPhotos(details: details) { [weak self] result in
            switch result {
            case .success(let photoResponse):
                let photos = photoResponse.photos
                self?.photoMaxCount = photoResponse.count
                DataManager.shared.photosAmount += photos.count
                
                DispatchQueue.main.asyncAndWait {
                    self?.view?.reloadList()
                }
                self?.downloadAndSavePhotos(photos, offset: offset)
                
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    private func getVideos(offset: Int) {
        guard let tokenString = getTokenString() else {return}
        let details = (accessToken: tokenString, offset: String(offset))
        
        NetworkService.shared.getVideos(details: details) { [weak self] result in
            switch result {
            case .success(let videoResponse):
                let videos = videoResponse.videos
                self?.videoMaxCount = videoResponse.count
                DataManager.shared.videosAmount += videos.count
                
                DispatchQueue.main.asyncAndWait {
                    self?.view?.reloadList()
                }
                self?.downloadAndSaveVideos(videos, offset: offset)
                
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    private func downloadAndSavePhotos(_ photos: [RawPhotoModel], offset: Int) {
        let group = DispatchGroup()
        for (index, photo) in photos.enumerated() {
            group.enter()
            NetworkService.shared.downloadPhoto(by: photo.urlString) { [weak self] result in
                switch result {
                case .success(let data):
                    let timeInterval = TimeInterval(photo.unixTime)
                    let creationDate = Date(timeIntervalSince1970: timeInterval)
                    let photoInstance = PhotoModel(data: data, creationDate: creationDate)
                    
                    DataManager.shared.savePhoto(photoInstance,
                                                 forKey: String(index + offset))
                    DispatchQueue.main.async {
                        self?.view?.reloadItem(at: index + offset)
                    }
                case .failure(let error):
                    self?.handleError(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .global()) {
            self.isDownloading = false
        }
    }
    
    private func downloadAndSaveVideos(_ videos: [RawVideoModel], offset: Int) {
        let group = DispatchGroup()
        for (index, video) in videos.enumerated() {
            group.enter()
            NetworkService.shared.downloadPhoto(by: video.previewURLString) { [weak self] result in
                switch result {
                case .success(let data):
                    let videoInstance = VideoModel(title: video.title,
                                                   preview: data,
                                                   playerURLString: video.playerURLString)
                    DataManager.shared.saveVideo(videoInstance,
                                                 forKey: String(index + offset))
                    
                    DispatchQueue.main.async {
                        self?.view?.reloadItem(at: index + offset)
                    }
                case .failure(let error):
                    self?.handleError(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .global()) {
            self.isDownloading = false
        }
    }
    
    private func getTokenString() -> String? {
        var tokenString: String?
        do {
            tokenString = try DataManager.shared.token(forKey: AccessToken.key)?.token
        } catch {
            handleError(error)
        }
        
        return tokenString
    }
    
    private func handleError(_ error: Error) {
        let message = ErrorHandler().handle(error: error)
        DispatchQueue.main.async {
            self.view?.showAlert(message: message)
        }
    }
    
    private func compressedImage(data: Data?) -> UIImage? {
        if let data,
           let compressedData = UIImage(data: data)?.jpegData(compressionQuality: 0.6) {
            return UIImage(data: compressedData)
        }
        return nil
    }
}
