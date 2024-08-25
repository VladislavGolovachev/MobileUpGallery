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
        if let error = error as? NetworkError {
            print("networkerror")
            return error.rawValue
        }
        return "Неизвестная ошибка"
    }
    
    func networkError(byStatusCode statusCode: Int) -> NetworkError {
        return NetworkError(value: statusCode)
    }
}
