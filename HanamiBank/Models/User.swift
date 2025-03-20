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
