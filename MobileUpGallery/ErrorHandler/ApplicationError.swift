//
//  ApplicationError.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 25.08.2024.
//

import Foundation

enum KeychainError: String, Error {
    case itemAlreadyExists = "Не удалось сохранить пароль"
    case itemNotFound = "Не удалось найти пароль"
    case unknownStatus = "Неизвестная ошибка, связанная с хранилищем ключей"
    
    init(status: OSStatus) {
        switch status {
        case errSecDuplicateItem:
            self = .itemAlreadyExists
        case errSecItemNotFound:
            self = .itemNotFound
        default:
            self = .unknownStatus
        }
    }
}

enum NetworkError: String, Error {
    case clientError = "Ошибка, связанная с сервером"
    case none = "Нет ошибки"
    case serverError = "Ошибка, связанная с клиентом"
    case notFound = "Не найдено"
    
    init(value: Int) {
        switch value {
        case 400...499:
            if value == 404 {
                self = .notFound
            } else {
                self = .clientError
            }
        case 500...599:
            self = .serverError
        default:
            self = .none
        }
    }
}

