//
//  Announcements.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 10.09.2025.
//

import Foundation


// MARK: - Announcements
struct AnnouncementsResponse: Decodable {
    let data: AnnouncementsData
    let success: Bool
}

// MARK: - DataClass
struct AnnouncementsData: Decodable {
    let announcements: [Announcement]
    let pagination: Pagination
}

// MARK: - Announcement
struct Announcement: Decodable {
    let content, createdAt, createdAtDisplay, creatorName: String
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case content
        case createdAt = "created_at"
        case createdAtDisplay = "created_at_display"
        case creatorName = "creator_name"
        case id, title
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    var currentPage: Int?
    var hasNext, hasPrev: Bool?
    var totalItems, totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
        case totalItems = "total_items"
        case totalPages = "total_pages"
    }
}
