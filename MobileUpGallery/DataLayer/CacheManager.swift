//
//  CacheManager.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import UIKit

protocol CacheManagerProtocol {
    func addItem(_ item: UIImage, forKey: String)
    func item(forKey key: String)
    func removeItem(forKey key: String)
}

//struct CacheManager: CacheManagerProtocol {
//    
//    private videoCache: NSCache<String, UIVideo>
//    private photoCache: NSCache<String, Image>
//    
//    func addItem(_ item: UIImage, for key: String) {
//        <#code#>
//    }
//    
//    func item(forKey key: String) {
//        <#code#>
//    }
//    
//    func removeItem(forKey key: String) {
//        <#code#>
//    }
//}
