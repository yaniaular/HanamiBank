//
//  User.swift
//  banca-hanami
//
//  Created by Yanina Aular on 13/03/25.
//

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let password: String
    let created_at: String
}

// Modelo para una cuenta individual
struct Account: Codable, Identifiable {
    let id: Int
    let created_at: String
    let user_id: Int
    let account_number: String
    let balance: Double
}

// Modelo para la respuesta de la API
struct BalanceResponse: Codable {
    let accounts: [Account]
}

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
