//
//  PhotoResponse.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

struct PhotoResponse: Decodable {
    var photos = [RawPhotoModel]()
    let count: Int
    
    init(from decoder: any Decoder) throws {
        let response = try RawPhotoResponse(from: decoder).response
        count = response.count
        
        for item in response.items {
            let date = item.date
            let photoSize = item.sizes.first {$0.type == "x"}
            let urlString = photoSize?.url ?? ""
            
            let photo = RawPhotoModel(unixTime: date, urlString: urlString)
            
            photos.append(photo)
        }
    }
}

struct RawPhotoModel {
    let unixTime: Int
    let urlString: String
}

struct RawPhotoResponse: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let items: [PhotoItem]
        let count: Int
    }
    struct PhotoItem: Decodable {
        let date: Int
        let sizes: [SizeItem]
    }
    struct SizeItem: Decodable {
        let url: String
        let type: String
    }
}
