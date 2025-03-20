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
