//
//  PollVoteResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 28.09.2025.
//

import Foundation

// MARK: - PollVoteResponse
struct PollVoteResponse: Codable {
    var data: PollVoteData?
    var error: JSONNull?
    var errorMessage: String?
    var msg: Int?
    var success: Bool?
}

// MARK: - DataClass
struct PollVoteData: Codable {
    var msg: String?
}
