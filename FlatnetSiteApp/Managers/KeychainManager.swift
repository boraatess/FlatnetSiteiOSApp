//
//  KeychainManager.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 10.09.2025.
//

import Foundation

// MARK: - UserProfile (UserDefaults için)
struct UserProfile: Codable {
    let id: Int
    let name: String
    let email: String
    let phoneNumber: String
    let daireNo: String
    let role: String
    let apartmentName: String
    let blockName: String
    let registirationDate: String
}

// MARK: - Keychain Helper
final class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}

    func save(_ data: Data, service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary) // overwrite
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        return result as? Data
    }

    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
    
    func clearAll() {
        let secItemClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ]
        
        for itemClass in secItemClasses {
            let query = [kSecClass as String: itemClass]
            SecItemDelete(query as CFDictionary)
        }
    }

    
}
