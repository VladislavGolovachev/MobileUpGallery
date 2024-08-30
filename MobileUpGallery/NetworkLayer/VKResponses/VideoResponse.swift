//
//  VideoResponse.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

struct VideoResponse: Decodable {
    var videos = [RawVideoModel]()
    let count: Int
    
    init(from decoder: any Decoder) throws {
        let response = try RawVideoResponse(from: decoder).response
        count = response.count
        
        for item in response.items {
            let image = item.image.max {
                $0.width * $0.height < $1.width * $1.height
            }
            guard let image else {return}
            
            let video = RawVideoModel(title: item.title,
                                      previewURLString: image.url,
                                      playerURLString: item.player)
            videos.append(video)
        }
    }
}

struct RawVideoModel: Decodable {
    let title: String
    let previewURLString: String
    let playerURLString: String
}

struct RawVideoResponse: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let items: [VideoItem]
        let count: Int
    }
    struct VideoItem: Decodable {
        let title: String
        let image: [VideoPreview]
        let player: String
    }
    struct VideoPreview: Decodable {
        let url: String
        let width: Int
        let height: Int
    }
}
