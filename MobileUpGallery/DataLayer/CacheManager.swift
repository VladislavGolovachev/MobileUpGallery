//
//  CacheManager.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import UIKit

protocol CacheManagerProtocol {
    func emptyPhotoCache()
    func emptyVideoCache()
    
    func addPhoto(_ photo: PhotoModel, forKey key: String)
    func photo(forKey key: String) -> PhotoModel?
    func addVideo(_ video: VideoModel, forKey key: String)
    func video(forKey key: String) -> VideoModel?
}

struct CacheManager: CacheManagerProtocol {
    private let photoCache = NSCache<NSString, StructWrapper<PhotoModel>>()
    private let videoCache = NSCache<NSString, StructWrapper<VideoModel>>()
    
    func addPhoto(_ photo: PhotoModel, forKey key: String) {
        let object = StructWrapper(value: photo)
        let nsStringKey = NSString(string: key)
        
        photoCache.setObject(object, forKey: nsStringKey)
    }
    
    func emptyPhotoCache() {
        photoCache.removeAllObjects()
    }
    
    func emptyVideoCache() {
        videoCache.removeAllObjects()
    }
    
    func photo(forKey key: String) -> PhotoModel? {
        let nsStringKey = NSString(string: key)
        let object = photoCache.object(forKey: nsStringKey)
        
        return object?.value
    }
    
    func addVideo(_ video: VideoModel, forKey key: String) {
        let object = StructWrapper(value: video)
        let nsStringKey = NSString(string: key)
        
        videoCache.setObject(object, forKey: nsStringKey)
    }
    
    func video(forKey key: String) -> VideoModel? {
        let nsStringKey = NSString(string: key)
        let object = videoCache.object(forKey: nsStringKey)
        
        return object?.value
    }
}
