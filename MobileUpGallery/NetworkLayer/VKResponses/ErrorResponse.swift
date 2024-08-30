//
//  ErrorResponse.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 30.08.2024.
//

import Foundation

struct ErrorResponse: Decodable {
    let error: ErrorType
    
    struct ErrorType: Decodable {
        let errorCode: Int
        
        private enum CodingKeys: String, CodingKey {
            case errorCode = "error_code"
        }
    }
}
