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
    let user_id: Int
    let account_number: String
    let balance: Double
    let created_at: String
}

// Modelo para la respuesta de la API
struct BalanceResponse: Codable {
    let accounts: [Account]
}

struct Saving: Codable, Identifiable {
    let id: UUID
    let name: String
    let amount: Double
}
