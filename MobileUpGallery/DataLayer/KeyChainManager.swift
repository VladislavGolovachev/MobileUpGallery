//
//  KeyChain.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

protocol KeychainManagerProtocol {
    func findItem(query: [CFString: Any]) throws -> [CFString: Any]?
    func addItem(query: [CFString: Any]) throws
    func updateItem(query: [CFString: Any], attributes: [CFString: Any]) throws
    func removeItem(query: [CFString: Any]) throws
}

protocol AccessTokenStorage {
    func addToken(_ accessToken: AccessToken, label: String) throws
    func removeToken(label: String) throws
    func updateToken(_ accessToken: AccessToken, label: String) throws
    func token(forLabel label: String) throws -> AccessToken?
}

final class SecureStorageManager: KeychainManagerProtocol {
    func findItem(query: [CFString: Any]) throws -> [CFString: Any]? {
        var ref: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &ref)
        
        if status != errSecSuccess {
            throw KeychainError(status: status)
        } else {
            return ref as? [CFString: Any]
        }
    }
    
    func addItem(query: [CFString: Any]) throws {
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
    
    func updateItem(query: [CFString: Any], attributes: [CFString: Any]) throws {
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
    
    func removeItem(query: [CFString: Any]) throws {
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
}

extension SecureStorageManager: AccessTokenStorage {
    
    func addToken(_ accessToken: AccessToken, label: String) throws {
        guard let tokenData = accessToken.token.data(using: .utf8) else {return}
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrLabel: label,
            kSecAttrCreationDate: accessToken.creationDate,
            kSecValueData: tokenData
        ]
        
        do {
            try addItem(query: query)
        } catch {
            throw(error)
        }
    }
    
    func removeToken(label: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrLabel: label
        ]

        do {
            try removeItem(query: query)
        } catch {
            throw(error)
        }
    }
    
    func updateToken(_ accessToken: AccessToken, label: String) throws {
        guard let tokenData = accessToken.token.data(using: .utf8) else {return}
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrLabel: label
        ]
        let attributes: [CFString: Any] = [
            kSecAttrCreationDate: accessToken.creationDate,
            kSecValueData: tokenData
        ]
        
        do {
            try updateItem(query: query, attributes: attributes)
        } catch {
            throw(error)
        }
    }
    
    func token(forLabel label: String) throws -> AccessToken? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrLabel: label,
            kSecReturnData: true,
            kSecReturnAttributes: true
        ]
        
        var result: [CFString: Any]?
        do {
            result = try findItem(query: query)
        } catch {
            throw(error)
        }
        
        if let result,
           let data = result[kSecValueData] as? Data,
           let token = String(data: data, encoding: .utf8),
           let creationDate = result[kSecAttrCreationDate] as? Date {
               return AccessToken(token: token, creationDate: creationDate)
           }
        
        return nil
    }
}
