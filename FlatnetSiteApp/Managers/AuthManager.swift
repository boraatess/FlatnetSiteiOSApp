//
//  AuthManager.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 10.09.2025.
//

import Foundation


// MARK: - AuthManager
final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    private let tokenService = "com.myapp.auth"
    private let tokenAccount = "accessToken"
    private let userKey = "userProfile"

    // MARK: - Save
    func saveSession(token: String, user: UserProfile) {
        // Save token → Keychain
        if let data = token.data(using: .utf8) {
            KeychainHelper.shared.save(data, service: tokenService, account: tokenAccount)
        }

        // Save user → UserDefaults
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }

    // MARK: - Getters
    var accessToken: String? {
        if let data = KeychainHelper.shared.read(service: tokenService, account: tokenAccount) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    var currentUser: UserProfile? {
        if let data = UserDefaults.standard.data(forKey: userKey) {
            return try? JSONDecoder().decode(UserProfile.self, from: data)
        }
        return nil
    }

    var isLoggedIn: Bool {
        return accessToken != nil
    }

    // MARK: - Clear
    func logout() {
        KeychainHelper.shared.delete(service: tokenService, account: tokenAccount)
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
