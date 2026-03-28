//
//  CraftsmenResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 17.09.2025.
//

import Foundation

// MARK: - Craftsmen
struct CraftsmenResponse: Codable {
    let data: [CraftsmenData]
    let success: Bool
}

struct CraftsmenData: Codable {
    let fullName: String
    let id: Int
    let notes: String
    let phoneNumber: String
    let specialty: String

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case id, notes
        case phoneNumber = "phone_number"
        case specialty
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try container.decode(String.self, forKey: .fullName)
        id = try container.decode(Int.self, forKey: .id)
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        specialty = try container.decodeIfPresent(String.self, forKey: .specialty) ?? ""
    }
}

