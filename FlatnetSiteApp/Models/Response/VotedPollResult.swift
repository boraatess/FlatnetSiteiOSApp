//
//  VotedPollResult.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 28.09.2025.
//

import Foundation

// MARK: - VotedPollResult
struct VotedPollResult: Codable {
    var data: PollResult?
    var success: Bool?
}

// MARK: - DataClass
struct PollResult: Codable {
    var id: Int?
    var question: String?
    var results: [ResultArray]?
    var totalVotes: Int?

    enum CodingKeys: String, CodingKey {
        case id, question, results
        case totalVotes = "total_votes"
    }
}

// MARK: - Result
struct ResultArray: Codable {
    var optionID: Int?
    var percentage: Double?
    var text: String?
    var votes: Int?

    enum CodingKeys: String, CodingKey {
        case optionID = "option_id"
        case percentage, text, votes
    }
}
