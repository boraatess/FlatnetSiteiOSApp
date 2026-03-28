//
//  RegisterRequest.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.09.2025.
//

import Foundation

// MARK: - RegisterRequest
struct RegisterRequest: Codable {
    let acceptKvkk, acceptPrivacy, acceptTerms: Bool
    let apartmentID: Int
    let blockID: Int?
    let confirmPassword, daireNo, email, firstName: String
    let lastName, password: String
    let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case acceptKvkk = "accept_kvkk"
        case acceptPrivacy = "accept_privacy"
        case acceptTerms = "accept_terms"
        case apartmentID = "apartment_id"
        case blockID = "block_id"
        case confirmPassword = "confirm_password"
        case daireNo = "daire_no"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case password
        case phoneNumber = "phone_number"
    }
    
}
