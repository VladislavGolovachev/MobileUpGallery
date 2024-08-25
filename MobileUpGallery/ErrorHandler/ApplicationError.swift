//
//  ApplicationError.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 25.08.2024.
//

import Foundation

enum KeychainError: Error {
    case itemAlreadyExists
    case itemNotFound
    case unknownStatus
    
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

enum NetworkError: Error {
    
}
