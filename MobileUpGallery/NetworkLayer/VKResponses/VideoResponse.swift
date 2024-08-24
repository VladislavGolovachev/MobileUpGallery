//
//  VideoResponse.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

struct VideoResponse: Decodable {
    var videos = [RawVideoModel]()
    
    init(from decoder: any Decoder) throws {
        let response = try RawVideoResponse(from: decoder).response
        
        for item in response.items {
            let image = item.image.max {
                $0.width * $0.height > $1.width * $1.height
            }
            
            let previewURLString = image?.url ?? ""
            let description = item.description
            let playerURLString = item.player
            
            let video = RawVideoModel(description: description,
                                      previewURLString: previewURLString,
                                      playerURLString: playerURLString)
            
            videos.append(video)
        }
    }
    
    struct RawVideoModel: Decodable {
        let description: String
        let previewURLString: String
        let playerURLString: String
    }
}

struct RawVideoResponse: Decodable {
    struct Response: Decodable {
        let items: [VideoItem]
    }
    struct VideoItem: Decodable {
        let description: String
        let image: [VideoPreview]
        let player: String
    }
    struct VideoPreview: Decodable {
        let url: String
        let width: Int
        let height: Int
    }
    let response: Response
}
