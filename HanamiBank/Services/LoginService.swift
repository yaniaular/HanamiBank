//
//  LoginService.swift
//  HanamiBank
//
//  Created by Yanina Aular on 18/03/25.
//

import SwiftUI
import Foundation

class LoginService {
    // Función para iniciar sesión
    func login(username: String, password: String, completion: @escaping (Bool, User?) -> Void) {
        BankService.shared.login(username: username, password: password.lowercased()) { success, user in
            if success, let user = user {
                completion(true, user)
            } else {
                completion(false, nil)
            }
        }
    }
    
    // Función para cerrar sesión
    func logout(userID: inout Int?, userName: inout String?) {
        // Limpiar datos guardados en AppStorage
        userID = nil
        userName = nil
    }
}
