//
//  RequestOptionsResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 19.09.2025.
//

import Foundation

// MARK: - RequestOptionsResponse
struct RequestOptionsResponse: Codable {
    let data: RequestOptionsDataClass
    let success: Bool
}

// MARK: - DataClass
struct RequestOptionsDataClass: Codable {
    let categories, locations, priorities: [Category]
}

// MARK: - Category
struct Category: Codable {
    let key, value: String
}


struct CreateRequestResponse: Decodable {
    let data: RequestData
    let error: String?
    let errorMessage: String
    let msg: String
    let success: Bool
}

struct RequestData: Decodable {
    let request: Request
}

struct Request: Decodable {
    let attachmentURL: String?
    let category: String
    let createdAt: String
    let description: String
    let id: Int
    let location: String
    let priority: String
    let status: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case attachmentURL = "attachment_url"
        case category
        case createdAt = "created_at"
        case description
        case id
        case location
        case priority
        case status
        case title
    }
}
