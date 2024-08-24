//
//  AccessToken.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

struct AccessToken {
    let token: String
    let creationDate: Date
    let lifeTime = TimeInterval(86400)
    static let key = "access_token"
    
    var isValid: Bool {
        let expiresInDate = Date(timeInterval: lifeTime, since: creationDate)
        let result = expiresInDate.compare(Date.now)
        
        return (result == .orderedDescending ? true : false)
    }
}
