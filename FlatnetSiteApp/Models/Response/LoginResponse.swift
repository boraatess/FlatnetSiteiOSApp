//
//  LoginResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let login = try? JSONDecoder().decode(Login.self, from: jsonData)

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let data: DataClass
    let error: String?
    let errorMessage: String?
    let msg: String?
    let success: Bool
}

// MARK: - DataClass
struct DataClass: Codable {
    let accessToken: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let apartment: Apartment?
    let block: Apartment?   // null geldiği için optional olmalı
    let daireNo: String
    let email: String
    let id: Int
    let name: String
    let phoneNumber: String?
    let registrationDateString: String
    let role: String

    enum CodingKeys: String, CodingKey {
        case apartment, block
        case daireNo = "daire_no"
        case email, id, name
        case phoneNumber = "phone_number"
        case registrationDateString = "registration_date_string"
        case role
    }
}

// MARK: - Apartment
struct Apartment: Codable {
    let id: Int
    let name: String
}


// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

/*
 import Foundation

 // MARK: - Ana Response
 struct APIResponse: Codable {
     let data: ResponseData?
     let error: String?
     let errorMessage: String?
     let msg: String?
     let success: Bool
 }

 // MARK: - Data
 struct ResponseData: Codable {
     let accessToken: String
     let user: User
     
     enum CodingKeys: String, CodingKey {
         case accessToken = "access_token"
         case user
     }
 }

 // MARK: - User
 struct User: Codable {
     let id: Int
     let name: String
     let email: String
     let phoneNumber: String
     let role: String
     let registrationDateString: String
     let daireNo: String
     let block: Block
     let apartment: Apartment

     enum CodingKeys: String, CodingKey {
         case id, name, email, role, block, apartment
         case phoneNumber = "phone_number"
         case registrationDateString = "registration_date_string"
         case daireNo = "daire_no"
     }
 }

 // MARK: - Block
 struct Block: Codable {
     let id: Int
     let name: String
 }

 // MARK: - Apartment
 struct Apartment: Codable {
     let id: Int
     let name: String
 }

 
 */
