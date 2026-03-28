//
//  SurveysResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let surveys = try? JSONDecoder().decode(Surveys.self, from: jsonData)

import Foundation

// MARK: - Surveys
struct SurveysResponse: Codable {
    let data: SurveysResponseDataClass
    let success: Bool
}

// MARK: - DataClass
struct SurveysResponseDataClass: Codable {
    let pagination: SurveyPagination
    let polls: [Surveys]
}

// MARK: - Pagination
struct SurveyPagination: Codable {
    let currentPage, totalPages: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

// MARK: - Surveys
struct Surveys: Codable {
    let createdAt: String
    let hasVoted: Bool
    let id: Int
    let options: [Option]
    let question: String

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case hasVoted = "has_voted"
        case id, options, question
    }
}

// MARK: - Option
struct Option: Codable {
    let id: Int
    let text: String
}

/* struct RuleSection {
 let title: String
 let content: String
 var isExpanded: Bool
}

 */

struct SurveySection {
    let id: Int
    let sectionTitle: String
    let createdAt: String
    let items: [Option]
    var isExpanded: Bool
    let hasVoted: Bool
    
}
