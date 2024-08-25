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
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: RouterProtocol)
    func showPhotoScreen()
    func showVideoScreen()
    func popToAuthScreen()
    
    func prefetchPhotos(forIndex index: Int)
    func photo(at index: Int) -> UIImage?
    func video(at index: Int) -> UIImage?
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
        let photo = DataManager.shared.photo(forkey: String(index))
        
        if photo == nil {
            isDownloading = true
            getPhotos(offset: index, count: count)
        }
    }
    
    func photo(at index: Int) -> UIImage? {
        let photoInstance = DataManager.shared.photo(forkey: String(index))
        if let photoData = photoInstance?.data,
           let data = UIImage(data: photoData)?.jpegData(compressionQuality: 0.6) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func video(at index: Int) -> UIImage? {
        return UIImage()
    }
    
    func showPhotoScreen() {
        router?.goToPhotoViewController()
    }
    
    func showVideoScreen() {
        router?.goToVideoViewController()
    }
    
    func popToAuthScreen() {
        router?.popToAuthViewController()
    }
}

//MARK: Private Functions
extension MainPresenter {
    private func getPhotos(offset: Int, count: Int) {
        guard let tokenString = DataManager.shared.token(forKey: AccessToken.key)?.token else {return}
        let details = (accessToken: tokenString, count: String(count), offset: String(offset))
        
        NetworkService.shared.getPhotos(details: details) { [weak self] result in
            self?.isDownloading = false
            switch result {
            case .success(let photoResponse):
                self?.savePhotos(photoResponse.photos, offset: offset)
            case .failure(let error):
                print(error.localizedDescription)
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
