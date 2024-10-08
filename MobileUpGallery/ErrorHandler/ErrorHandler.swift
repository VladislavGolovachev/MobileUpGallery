//
//  ErrorHandler.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 25.08.2024.
//

import Foundation

struct ErrorHandler {
    func handle(error: Error) -> String {
        if let error = error as? KeychainError {
            return error.rawValue
        }
        if let error = error as? VKError {
            return error.rawValue
        }
        if let error = error as? NetworkError {
            return error.rawValue
        }
        return "Неизвестная ошибка"
    }
    
    func networkError(byStatusCode statusCode: Int) -> NetworkError {
        return NetworkError(value: statusCode)
    }
    
    func vkError(byResponseCode responseCode: Int) -> VKError {
        return VKError(responseCode: responseCode)
    }
}
