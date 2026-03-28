//
//  DuesResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 17.09.2025.
//

import Foundation

// MARK: - Dues
struct DuesResponse: Decodable {
    let data: DuesDataClass
    let success: Bool
}

// MARK: - DataClass
struct DuesDataClass: Decodable {
    let duesList: [DuesList]
    let pagination: Pagination
    let totalDebt: Int
    let totalDebtDisplay: String

    enum CodingKeys: String, CodingKey {
        case duesList = "dues_list"
        case pagination
        case totalDebt = "total_debt"
        case totalDebtDisplay = "total_debt_display"
    }
}

// MARK: - DuesList
struct DuesList: Codable {
    let amount: Int
    let amountDisplay, description, dueDate: String
    let id: Int
    let period, status: String

    enum CodingKeys: String, CodingKey {
        case amount
        case amountDisplay = "amount_display"
        case description
        case dueDate = "due_date"
        case id, period, status
    }
}

struct ReceiptResponse: Decodable {
    let data: ReceiptData
    let success: Bool
}

struct ReceiptData: Decodable {
    let dues_id: Int
    let receipt_url: String
    let upload_date: String
}
