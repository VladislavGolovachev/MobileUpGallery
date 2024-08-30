//
//  VKURL.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 23.08.2024.
//

import Foundation

struct VKURL {
    private enum QueryValues {
        static let cliendID = "51793431"
        static let display = "mobile"
        static let redirectURI = "https://oauth.vk.com/blank.html"
        static let scope = "20"
        static let responseType = "token"
        static let ownerID = "-128666765"
        static let photoCount = "20"
        static let videoCount = "10"
        static let version = "5.199"
    }
    
    static func getAuthURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id",     value: QueryValues.cliendID),
            URLQueryItem(name: "display",       value: QueryValues.display),
            URLQueryItem(name: "redirect_uri",  value: QueryValues.redirectURI),
            URLQueryItem(name: "scope",         value: QueryValues.scope),
            URLQueryItem(name: "response_type", value: QueryValues.responseType),
            URLQueryItem(name: "v",             value: QueryValues.version)
        ]
        
        return urlComponents.url
    }
    
    static func getAPIURL(for method: APIMethod, with details: (accessToken: String, offset: String)) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: details.accessToken),
            URLQueryItem(name: "owner_id",     value: QueryValues.ownerID),
            URLQueryItem(name: "v",            value: QueryValues.version),
            URLQueryItem(name: "offset",       value: details.offset)
        ]
        
        switch method {
        case .photos:
            urlComponents.path = "/method/photos.getAll"
            let queryItem = URLQueryItem(name: "count", value: QueryValues.photoCount)
            urlComponents.queryItems?.append(queryItem)
            
        case .videos:
            urlComponents.path = "/method/video.get"
            let queryItem = URLQueryItem(name: "count", value: QueryValues.videoCount)
            urlComponents.queryItems?.append(queryItem)
        }
        
        return urlComponents.url
    }
}
