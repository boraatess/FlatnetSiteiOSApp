//
//  ForgotPasswordResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.09.2025.
//

import Foundation


// MARK: - ForgotPassword
struct ForgotPasswordResponse: Codable {
    let data: ForgotPasswordMessage
    let error: JSONNull?
    let errorMessage, msg: String
    let success: Bool
}

// MARK: - DataClass
struct ForgotPasswordMessage: Codable {
    let msg: String
}
