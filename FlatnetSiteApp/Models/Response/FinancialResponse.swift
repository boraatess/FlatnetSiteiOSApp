//
//  FinancialResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation

// MARK: - Financial

struct FinancialResponse: Codable {
    let data: ExpenseData
    let error: String?
    let errorMessage: String
    let msg: String
    let success: Bool
}

// MARK: - Data
struct ExpenseData: Codable {
    let currentMonthName: String
    let expenseList: [Expense]
    let incomeList: [Income]
    let totalBalance: Double
    let totalBalanceDisplay: String
    let totalExpense: Double
    let totalExpenseDisplay: String
    let totalIncome: Double
    let totalIncomeDisplay: String

    enum CodingKeys: String, CodingKey {
        case currentMonthName = "current_month_name"
        case expenseList = "expense_list"
        case incomeList = "income_list"
        case totalBalance = "total_balance"
        case totalBalanceDisplay = "total_balance_display"
        case totalExpense = "total_expense"
        case totalExpenseDisplay = "total_expense_display"
        case totalIncome = "total_income"
        case totalIncomeDisplay = "total_income_display"
    }
}

// MARK: - Expense
struct Expense: Codable {
    let id: Int?
    let description: String?
    let amount: Double?
    let amount_display: String?
    let date_display: String?
    let invoice_url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, description, amount, amount_display, date_display, invoice_url
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        amount = try c.decodeIfPresent(Double.self, forKey: .amount)
        amount_display = try c.decodeIfPresent(String.self, forKey: .amount_display)
        date_display = try c.decodeIfPresent(String.self, forKey: .date_display)
        invoice_url = try c.decodeIfPresent(String.self, forKey: .invoice_url)
    }
}

// MARK: - Income
struct Income: Codable {
    let id: Int?
    let description: String?
    let amount: Double?
    let amount_display: String?
    let date_display: String?
    let invoice_url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, description, amount, amount_display, date_display, invoice_url
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        amount = try c.decodeIfPresent(Double.self, forKey: .amount)
        amount_display = try c.decodeIfPresent(String.self, forKey: .amount_display)
        date_display = try c.decodeIfPresent(String.self, forKey: .date_display)
        invoice_url = try c.decodeIfPresent(String.self, forKey: .invoice_url)
    }
}
