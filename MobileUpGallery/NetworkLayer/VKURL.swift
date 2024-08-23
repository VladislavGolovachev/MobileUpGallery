//
//  VKURL.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 23.08.2024.
//

import Foundation

struct VKURL {
    static func getAuthURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "51793431"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "20"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.199")
        ]
        
        return urlComponents.url
    }
    
    static func getAPIURL(for method: APIMethod, with details: (accessToken: String, count: String, offset: String)) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: details.accessToken),
            URLQueryItem(name: "owner_id", value: "128666765"),
            URLQueryItem(name: "v", value: "5.199"),
            URLQueryItem(name: "count", value: details.count),
            URLQueryItem(name: "offset", value: details.offset)
        ]
        
        switch method {
        case .photos:
            urlComponents.path = "/method/photos.getAll"
        case .videos:
            urlComponents.path = "/method/video.get"
        }
        
        return urlComponents.url
    }
}
