//
//  BankService.swift
//  banca-hanami
//
//  Created by Yanina Aular on 13/03/25.
//

import Foundation

class BankService {
    static let shared = BankService()
    private let baseURL = "http://example.com/api"

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Simulamos un login exitoso
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(username == "user" && password == "password")
        }
    }

    func getBalance(completion: @escaping (Double?) -> Void) {
        let url = URL(string: "\(baseURL)/balance")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let response = try? JSONDecoder().decode(BalanceResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response?.balance)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
