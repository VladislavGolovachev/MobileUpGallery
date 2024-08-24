//
//  PhotosResponse.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

struct PhotosResponse: Decodable {
    var photos = [RawPhotoModel]()
    
    init(from decoder: any Decoder) throws {
        let response = try RawPhotosResponse(from: decoder).response
        
        response.items.forEach {
            let date = $0.date
            let urlString = $0.originalPhoto.url
            let photo = RawPhotoModel(date: date, urlString: urlString)
            
            photos.append(photo)
        }
    }
    
    struct RawPhotoModel {
        let date: String
        let urlString: String
    }
}

struct RawPhotosResponse: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let items: [PhotoItem]
    }
    struct PhotoItem: Decodable {
        let date: String
        let originalPhoto: OriginalPhoto
        
        enum CodingKeys: String, CodingKey {
            case date = "date"
            case originalPhoto = "orig_photo"
        }
    }
    struct OriginalPhoto: Decodable {
        let url: String
    }
}
