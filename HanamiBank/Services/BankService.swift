//
//  BankService.swift
//  banca-hanami
//
//  Created by Yanina Aular on 13/03/25.
//

import Foundation
import SwiftUI

class BankService {
    static let shared = BankService()
    private let baseURL = URL(string: "https://yaniaular.pythonanywhere.com")
    @AppStorage(Constants.userIDKey) private var userID: Int?

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

    func getAccount(account_id: Int, completion: @escaping (Account?) -> Void) {
        let url = baseURL!.appendingPathComponent("/api/account/\(account_id)") // Consultar una cuenta
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let response = try? JSONDecoder().decode(Account.self, from: data)
                DispatchQueue.main.async {
                    completion(response)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func getAllAccounts(user_id: Int, completion: @escaping ([Account]?) -> Void) {
        let url = baseURL!.appendingPathComponent("/api/users/\(user_id)/accounts") // Consultar todas las cuentas del usuario
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let response = try? JSONDecoder().decode(AccountResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response?.accounts)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

    func getAllSavings(user_id: Int, completion: @escaping ([Saving]?) -> Void) {
        let url = baseURL!.appendingPathComponent("/api/users/\(user_id)/savings") // Consultar todas las cuentas del usuario
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let response = try? JSONDecoder().decode(SavingResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response?.savings)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

    func getAllTransactions(account_id: Int, completion: @escaping ([Transaction]?) -> Void) {
        let url = baseURL!.appendingPathComponent("/api/accounts/\(account_id)/transactions") // Consultar todas las cuentas del usuario
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let response = try? JSONDecoder().decode(TransactionResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response?.transactions)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func doTransfer(sourceAccountNumber: String,
                      destinationAccountNumber: String,
                      amount: Double,
                      completion: @escaping (Bool, TransferResponse?, String?) -> Void) {
        
        guard let url = baseURL?.appendingPathComponent("/api/transfers") else {
            completion(false, nil, "Invalid URL")
            return
        }

        // Create request body
        let body: [String: Any] = [
            "source_account_number": sourceAccountNumber,
            "destination_account_number": destinationAccountNumber,
            "amount": amount
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(false, nil, "Failed to encode request data")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, nil, "Network error: \(error.localizedDescription)")
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, nil, "Invalid server response")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, nil, "No data received")
                }
                return
            }

            // Check for successful status code
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let transferResponse = try JSONDecoder().decode(TransferResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(true, transferResponse, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, nil, "Failed to decode response: \(error.localizedDescription)")
                    }
                }
            } else {
                // Handle server errors
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                   let errorMessage = errorResponse["error"] {
                    DispatchQueue.main.async {
                        completion(false, nil, errorMessage)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, nil, "Transfer failed with status code: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }
    
    func manageSaving(action: SavingAction, completion: @escaping (Result<SavingTransactionResponse, Error>) -> Void) {
        guard let url = baseURL?.appendingPathComponent("/api/savings/transaction") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(action)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SavingTransactionResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func createSaving(name: String, amount: Double, completion: @escaping (Bool) -> Void) {
        guard let url = baseURL?.appendingPathComponent("/api/savings"),
        let userId = userID else {
            completion(false)
            return
        }
        
        let body: [String: Any] = [
            "user_id": userId,
            "name": name,
            "amount": amount
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            let success = (error == nil) &&
                         ((response as? HTTPURLResponse)?.statusCode == 201)
            DispatchQueue.main.async {
                completion(success)
            }
        }.resume()
    }
    
}
