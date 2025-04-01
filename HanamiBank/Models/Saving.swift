//
//  Saving.swift
//  HanamiBank
//
//  Created by Yanina Aular on 20/03/25.
//

import Foundation

struct Saving: Codable, Identifiable {
    let id: Int
    let created_at: String
    let user_id: Int
    let name: String
    let amount: Double
}

struct SavingResponse: Codable {
    let savings: [Saving]
}

struct SavingAction: Codable {
    let saving_id: Int
    let account_id: Int
    let amount: Double
}

struct SavingTransactionResponse: Codable {
    let message: String
    let newAccountBalance: Double
    let newSavingBalance: Double
    
    private enum CodingKeys: String, CodingKey {
        case message
        case newAccountBalance = "new_account_balance"
        case newSavingBalance = "new_saving_balance"
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
}
