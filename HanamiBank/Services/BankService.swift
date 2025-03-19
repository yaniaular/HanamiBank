//
//  BankService.swift
//  banca-hanami
//
//  Created by Yanina Aular on 13/03/25.
//

import Foundation

class BankService {
    static let shared = BankService()
    private let baseURL = URL(string: "https://yaniaular.pythonanywhere.com")

    func login(username: String, password: String, completion: @escaping (Bool, User?) -> Void) {
        guard let url = baseURL?.appendingPathComponent("api/users/login") else {
            completion(false, nil)
            return
        }

        // Crear el cuerpo de la solicitud
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        completion(true, user)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }.resume()
    }

    func getAllAccounts(user_id: Int, completion: @escaping ([Account]?) -> Void) {
        let url = baseURL!.appendingPathComponent("/api/users/\(user_id)/accounts") // Consultar todas las cuentas del usuario
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let response = try? JSONDecoder().decode(BalanceResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response?.accounts)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

}
