//
//  DataManager.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

protocol DataManagerProtocol {
    func photo(forKey key: String) -> PhotoModel?
    func video(forKey key: String) -> VideoModel?
    func savePhoto(_ image: PhotoModel, forKey key: String)
    func saveVideo(_ video: VideoModel, forKey key: String)
    
    func token(forKey key: String) throws -> AccessToken?
    func updateToken(_ token: AccessToken, forKey key: String) throws
    func saveToken(_ token: AccessToken, forKey key: String) throws
    func removeToken(forKey key: String) throws
    
    func emptyPhotoCache()
    func emptyVideoCache()
    
    var photosAmount: Int {get set}
    var videosAmount: Int {get set}
}

final class DataManager: DataManagerProtocol {
    let itemQueue = DispatchQueue(label: "vladislav-golovachev-itemQueue", qos: .utility, attributes: .concurrent)
    
    var photosAmount = 0
    var videosAmount = 0
    
    static let shared = DataManager()
    private let cacheManager = CacheManager()
    private let tokenManager = SecureStorageManager() as AccessTokenStorage
    
    private init() {}
    
    func emptyPhotoCache() {
        cacheManager.emptyPhotoCache()
        photosAmount = 0
    }
    
    func emptyVideoCache() {
        cacheManager.emptyVideoCache()
        videosAmount = 0
    }
    
    func photo(forKey key: String) -> PhotoModel? {
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
        itemQueue.asyncAndWait {
            self.cacheManager.addPhoto(image, forKey: key)
        }
    }
    
    func saveVideo(_ video: VideoModel, forKey key: String) {
        itemQueue.asyncAndWait {
            self.cacheManager.addVideo(video, forKey: key)
        }
    }
    
    func token(forKey key: String) throws -> AccessToken? {
        var token: AccessToken?
        do {
            token = try tokenManager.token(forLabel: key)
        } catch {
            throw(error)
        }
        
        return token
    }
    
    func updateToken(_ token: AccessToken, forKey key: String) throws {
        var varToken: AccessToken?
        
        do {
            varToken = try self.token(forKey: key)
        } catch {}
        
        if varToken != nil {
            do {
                try removeToken(forKey: key)
            } catch {
                throw(error)
            }
        }
        
        do {
            try saveToken(token, forKey: key)
        } catch {
            throw(error)
        }
    }
    
    func saveToken(_ token: AccessToken, forKey key: String) throws {
        do {
            try tokenManager.addToken(token, label: key)
        } catch {
            throw(error)
        }
    }
    
    func removeToken(forKey key: String) throws {
        do {
            try tokenManager.removeToken(label: key)
        } catch {
            throw(error)
        }
    }
}
