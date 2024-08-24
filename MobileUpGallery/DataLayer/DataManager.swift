//
//  DataManager.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

protocol DataManagerProtocol {
    func photo(forkey key: String) -> PhotoModel?
    func video(forKey key: String) -> VideoModel?
    func savePhoto(_ image: PhotoModel, forKey key: String)
    func saveVideo(_ video: VideoModel, forKey key: String)
    
    func token(forKey key: String) -> AccessToken?
    func updateToken(with token: AccessToken, forKey key: String)
    func saveToken(_ token: AccessToken, forKey key: String)
    func removeToken(forKey key: String)
}

final class DataManager: DataManagerProtocol {
    let tokenQueue = DispatchQueue(label: "vladislav-golovachev-tokenQueue", qos: .utility)
    let itemQueue = DispatchQueue(label: "vladislav-golovachev-itemQueue", qos: .utility, attributes: .concurrent)
    static let shared = DataManager()
    private let cacheManager = CacheManager()
    private let tokenManager = SecureStorageManager() as AccessTokenStorage
    private init() {}
    
    func photo(forkey key: String) -> PhotoModel? {
        var photoInstance: PhotoModel?
        itemQueue.asyncAndWait {
            photoInstance = cacheManager.photo(forKey: key)
        }
        
        return photoInstance
    }
    
    func video(forKey key: String) -> VideoModel? {
        var videoInstance: VideoModel?
        itemQueue.asyncAndWait {
            videoInstance = cacheManager.video(forKey: key)
        }
        
        return videoInstance
    }
    
    func savePhoto(_ image: PhotoModel, forKey key: String) {
        itemQueue.async {
            self.cacheManager.addPhoto(image, forKey: key)
        }
    }
    
    func saveVideo(_ video: VideoModel, forKey key: String) {
        itemQueue.async {
            self.cacheManager.addVideo(video, forKey: key)
        }
    }
    
    func token(forKey key: String) -> AccessToken? {
        var token: AccessToken?
        tokenQueue.asyncAndWait {
            do {
                token = try tokenManager.token(forLabel: key)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return token
    }
    
    func updateToken(with token: AccessToken, forKey key: String) {
        removeToken(forKey: key)
        saveToken(token, forKey: key)
    }
    
    func saveToken(_ token: AccessToken, forKey key: String) {
        tokenQueue.async {
            do {
                try self.tokenManager.addToken(token, label: key)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeToken(forKey key: String) {
        tokenQueue.async {
            do {
                try self.tokenManager.removeToken(label: key)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
