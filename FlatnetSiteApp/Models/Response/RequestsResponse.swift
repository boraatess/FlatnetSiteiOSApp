//
//  RequestsResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 24.09.2025.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let requestsResponse = try? JSONDecoder().decode(RequestsResponse.self, from: jsonData)

import Foundation

// MARK: - RequestsResponse
struct RequestsResponse: Codable {
    var data: RequestsData?
    var success: Bool?
}

// MARK: - DataClass
struct RequestsData: Codable {
    var pagination: Pagination?
    var requests: [RequestArray]?
}

// MARK: - Request
struct RequestArray: Codable {
    var attachmentURL, category, createdAt, description: String?
    var id: Int?
    var location, priority, reply, status: String?
    var statusDisplay: StatusDisplay?
    var title, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case attachmentURL = "attachment_url"
        case category
        case createdAt = "created_at"
        case description, id, location, priority, reply, status
        case statusDisplay = "status_display"
        case title
        case updatedAt = "updated_at"
    }
}

// MARK: - StatusDisplay
struct StatusDisplay: Codable {
    var color, text: String?
}

