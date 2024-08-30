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

enum VKError: String, Error {
    case unknownError = "Неизвестная ошибка"
    case appIsOff = "Приложение выключено"
    case authHasBeenFailed = "Авторизация пользователя не удалась"
    case tooManyRequests = "Слишком много запросов в секунду"
    case innerServerError = "Произошла внутренняя ошибка сервера"
    case accessDenied = "Доступ запрещен"
    case accessKeyOfGroupIsInvalid = "Ключ доступа сообщества недействителен"
    case accessKeyOfAppIsInvalid = "Ключ доступа приложения недействителен"
    
    init(responseCode: Int) {
        switch responseCode {
        case 2:
            self = .appIsOff
        case 5:
            self = .authHasBeenFailed
        case 6:
            self = .tooManyRequests
        case 10:
            self = .innerServerError
        case 15:
            self = .accessDenied
        case 27:
            self = .accessKeyOfGroupIsInvalid
        case 28:
            self = .accessKeyOfAppIsInvalid
        default:
            self = .unknownError
        }
    }
}
