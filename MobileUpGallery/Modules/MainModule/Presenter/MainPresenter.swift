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
    
    func prefetchPhotos(forIndex index: Int)
    func prefetchVideos(for Index: Int)
    func photo(at index: Int) -> UIImage?
    func video(at index: Int) -> UIImage?
    func videoTitle(at index: Int) -> String?
    var photosAmount: Int {get}
    var videosAmount: Int {get}
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    
    private var isDownloading = false
    
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
    
    func prefetchPhotos(forIndex index: Int) {
        if isDownloading {
            return
        }
        let count = 20
        let photo = DataManager.shared.photo(forKey: String(index))
        
        if photo == nil {
            isDownloading = true
            getPhotos(offset: index, count: count)
        }
    }
    
    func prefetchVideos(for index: Int) {
        if isDownloading {
            return
        }
        let count = 10
        let video = DataManager.shared.video(forKey: String(index))
        
        if video == nil {
            isDownloading = true
            getVideos(offset: index, count: count)
        }
    }
    
    func photo(at index: Int) -> UIImage? {
        let photoInstance = DataManager.shared.photo(forKey: String(index))
        if let photoData = photoInstance?.data,
           let data = UIImage(data: photoData)?.jpegData(compressionQuality: 0.6) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func video(at index: Int) -> UIImage? {
        let videoInstance = DataManager.shared.video(forKey: String(index))
        if let videoData = videoInstance?.preview,
           let data = UIImage(data: videoData)?.jpegData(compressionQuality: 0.7) {
            return UIImage(data: data)
        }
        return nil
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
            let message = ErrorHandler().handle(error: error)
            view?.showAlert(message: message)
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
    func getTokenString() throws -> String? {
        var tokenString: String?
        do {
            tokenString = try DataManager.shared.token(forKey: AccessToken.key)?.token
        } catch {
            throw(error)
        }
        
        return tokenString
    }
    
    private func getPhotos(offset: Int, count: Int) {
        var token: String?
        do {
            token = try getTokenString()
        } catch {
            view?.showAlert(message: ErrorHandler().handle(error: error))
            return
        }
        guard let tokenString = token else {return}
        let details = (accessToken: tokenString, count: String(count), offset: String(offset))
        
        NetworkService.shared.getPhotos(details: details) { [weak self] result in
            switch result {
            case .success(let photoResponse):
                self?.savePhotos(photoResponse.photos, offset: offset)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.isDownloading = false
        }
    }
    
    private func getVideos(offset: Int, count: Int) {
        var token: String?
        do {
            token = try getTokenString()
        } catch {
            view?.showAlert(message: ErrorHandler().handle(error: error))
            return
        }
        guard let tokenString = token else {return}
        let details = (accessToken: tokenString, count: String(count), offset: String(offset))
        
        NetworkService.shared.getVideos(details: details) { [weak self] result in
            switch result {
            case .success(let videoResponse):
                self?.saveVideos(videoResponse.videos, offset: offset)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.isDownloading = false
        }
    }
    
    private func saveVideos(_ videos: [RawVideoModel], offset: Int) {
        DataManager.shared.videosAmount += videos.count
        DispatchQueue.main.asyncAndWait {
            view?.reloadList()
        }
        
        for (index, video) in videos.enumerated() {
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
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func savePhotos(_ photos: [RawPhotoModel], offset: Int) {
        DataManager.shared.photosAmount += photos.count
        DispatchQueue.main.asyncAndWait {
            view?.reloadList()
        }
        
        for (index, photo) in photos.enumerated() {
            let timeInterval = TimeInterval(photo.unixTime)
            let creationDate = Date(timeIntervalSince1970: timeInterval)
            
            NetworkService.shared.downloadPhoto(by: photo.urlString) { [weak self] result in
                switch result {
                case .success(let data):
                    let photoInstance = PhotoModel(data: data, creationDate: creationDate)
                    DataManager.shared.savePhoto(photoInstance,
                                                 forKey: String(index + offset))
                    DispatchQueue.main.async {
                        self?.view?.reloadItem(at: index + offset)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
