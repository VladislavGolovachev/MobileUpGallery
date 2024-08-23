//
//  NetworkService.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 23.08.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func authRequest() -> URLRequest?
    func getPhotos(details: (accessToken: String, count: String, offset: String))
    func getVideos(details: (accessToken: String, count: String, offset: String))
}

struct NetworkService {
    static let shared = NetworkService()
    private init() {}
}

//MARK: Private Functions
extension NetworkService {
    private func request(_ request: VKRequest) -> URLRequest? {
        return request.construct()
    }
}

//MARK: NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
    func authRequest() -> URLRequest? {
        return request(.auth)
    }
    
    func getPhotos(details: (accessToken: String, count: String, offset: String)) {
        guard let urlRequest = request(.api(.photos, details: details)) else {return}
    }
    
    func getVideos(details: (accessToken: String, count: String, offset: String)) {
        guard let urlRequest = request(.api(.videos, details: details)) else {return}
    }
}
