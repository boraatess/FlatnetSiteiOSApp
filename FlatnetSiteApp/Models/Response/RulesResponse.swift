//
//  RulesResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.09.2025.
//

import Foundation

// MARK: - Rules
struct RulesResponse: Codable {
    let data: [RulesData]
    let success: Bool
}

// MARK: - Datum
struct RulesData: Codable {
    let content, title: String
}

struct RuleSection {
    let title: String
    let content: String
    var isExpanded: Bool
}
