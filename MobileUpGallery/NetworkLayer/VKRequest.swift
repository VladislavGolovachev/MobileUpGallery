//
//  VKRequest.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 23.08.2024.
//

import Foundation

protocol URLRequestConstructer {
    func construct() -> URLRequest?
}

enum VKRequest {
    case auth
    case api(_ method: APIMethod, details: (accessToken: String, offset: String))
}

enum APIMethod {
    case photos
    case videos
}

extension VKRequest: URLRequestConstructer {
    func construct() -> URLRequest? {
        switch self {
        case .auth:
            return authRequest()
        case .api(let method, let details):
            return apiRequest(method, details: details)
        }
    }
    
    private func authRequest() -> URLRequest? {
        guard let url = VKURL.getAuthURL() else {return nil}
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
    
    private func apiRequest(_ method: APIMethod, details: (accessToken: String, offset: String)) -> URLRequest? {
        guard let url = VKURL.getAPIURL(for: method, with: details) else {return nil}
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
}
