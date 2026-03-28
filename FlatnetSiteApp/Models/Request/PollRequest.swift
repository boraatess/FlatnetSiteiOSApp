//
//  PollRequest.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 28.09.2025.
//

import Foundation

struct PollRequest: Codable {
    var optionID: Int?

    enum CodingKeys: String, CodingKey {
        case optionID = "option_id"
    }
}
