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
            return handleKeychainError(error)
        }
        if let error = error as? NetworkError {
            return handleNetworkError(error)
        }
        return "Неизвестная ошибка"
    }
    
    private func handleKeychainError(_ error: KeychainError) -> String {
        switch error {
        case .itemAlreadyExists:
            return "Не удалось сохранить пароль"
        case .itemNotFound:
            return "Не удалось найти пароль"
        case .unknownStatus:
            return "Неизвестная ошибка, связанная с хранилищем ключей"
        }
    }
    
    private func handleNetworkError(_ error: NetworkError) -> String {
        
    }
}
