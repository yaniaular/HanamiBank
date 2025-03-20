//
//  Account.swift
//  HanamiBank
//
//  Created by Yanina Aular on 20/03/25.
//

import Foundation

// Modelo para una cuenta individual
struct Account: Codable, Identifiable {
    let id: Int
    let created_at: String
    let user_id: Int
    let account_number: String
    let balance: Double
}

// Modelo para la respuesta de la API
struct AccountResponse: Codable {
    let accounts: [Account]
}
