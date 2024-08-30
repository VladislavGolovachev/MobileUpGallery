//
//  NetworkService.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 23.08.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func authRequest() -> URLRequest?
    func getPhotos(details: (accessToken: String, offset: String), 
                   completion: @escaping (Result<PhotoResponse, Error>) -> Void)
    func getVideos(details: (accessToken: String, offset: String), 
                   completion: @escaping (Result<VideoResponse, Error>) -> Void)
    func downloadPhoto(by urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
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
    
    private func getError(by response: URLResponse?) -> Error? {
        if let httpResponse = response as? HTTPURLResponse {
            let status = httpResponse.statusCode
            let error = ErrorHandler().networkError(byStatusCode: status)
            if error != .none {
                return error as Error
            }
        }
        return nil
    }
}

//MARK: NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
    func authRequest() -> URLRequest? {
        return request(.auth)
    }
    
    func getPhotos(details: (accessToken: String, offset: String),
                   completion: @escaping (Result<PhotoResponse, Error>) -> Void) {
        guard let getPhotosRequest = request(.api(.photos, details: details)) else {return}
        
        let task = URLSession.shared.dataTask(with: getPhotosRequest) { data, response, error in
            if let possibleError = getError(by: response) {
                completion(.failure(possibleError))
                return
            }
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {return}
            do {
                let photoResponse = try JSONDecoder().decode(PhotoResponse.self, from: data)
                completion(.success(photoResponse))
            } catch {
                print(String(data: data, encoding: .utf8))
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    func getVideos(details: (accessToken: String, offset: String),
                   completion: @escaping (Result<VideoResponse, Error>) -> Void) {
        guard let getVideosRequest = request(.api(.videos, details: details)) else {return}
        
        let task = URLSession.shared.dataTask(with: getVideosRequest) { data, response, error in
            if let possibleError = getError(by: response) {
                completion(.failure(possibleError))
                return
            }
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {return}
            do {
                let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
                completion(.success(videoResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func downloadPhoto(by urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let possibleError = getError(by: response) {
                completion(.failure(possibleError))
                return
            }
            if let error {
                completion(.failure(error))
                return
            }
            
            if let data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
