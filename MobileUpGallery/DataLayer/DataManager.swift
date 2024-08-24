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
    static let shared = DataManager()
    private let cacheManager = CacheManager()
    private let tokenManager = SecureStorageManager() as AccessTokenStorage
    private init() {}
    
    func photo(forkey key: String) -> PhotoModel? {
        return cacheManager.photo(forKey: key)
    }
    
    func video(forKey key: String) -> VideoModel? {
        return cacheManager.video(forKey: key)
    }
    
    func savePhoto(_ image: PhotoModel, forKey key: String) {
        cacheManager.addPhoto(image, forKey: key)
    }
    
    func saveVideo(_ video: VideoModel, forKey key: String) {
        cacheManager.addVideo(video, forKey: key)
    }
    
    func token(forKey key: String) -> AccessToken? {
        do {
            let token = try tokenManager.token(forLabel: key)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func updateToken(with token: AccessToken, forKey key: String) {
        removeToken(forKey: key)
        saveToken(token, forKey: key)
    }
    
    func saveToken(_ token: AccessToken, forKey key: String) {
        do {
            try tokenManager.addToken(token, label: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeToken(forKey key: String) {
        do {
            try tokenManager.removeToken(label: key)
        } catch {
            print(error.localizedDescription)
        }
    }
}
