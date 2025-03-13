//
//  User.swift
//  banca-hanami
//
//  Created by Yanina Aular on 13/03/25.
//

import Foundation

struct User: Codable {
    var username: String
    var password: String
}

struct BalanceResponse: Codable {
    var balance: Double
}
