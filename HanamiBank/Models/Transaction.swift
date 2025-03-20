//
//  Transaction.swift
//  HanamiBank
//
//  Created by Yanina Aular on 20/03/25.
//

import Foundation

struct Transaction: Codable, Identifiable {
    let id: Int
    let created_at: String
    let user_id: Int
    let account_id: Int
    let description: String
    let type: String
    let amount: Double
}

struct TransactionResponse: Codable {
    let transactions: [Transaction]
}
