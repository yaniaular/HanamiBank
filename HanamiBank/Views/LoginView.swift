//
//  LoginView.swift
//  banca-hanami
//
//  Created by Yanina Aular on 13/03/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @AppStorage(Constants.userIDKey) private var userID: Int?

    // Binding computado para navigationDestination
    private var isLoggedIn: Binding<Bool> {
        Binding(
            get: { userID != nil }, // true si userID no es nil
            set: { newValue in
                if !newValue {
                    userID = nil // Si se establece en false, elimina el userID
                }
            }
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)

                Button("Login") {
                    BankService.shared.login(username: username, password: password.lowercased()) { success, user in
                        if success, let user = user {
                            userID = user.id // Guardar el user_id en @AppStorage
                        } else {
                            showError = true
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                if showError {
                    Text("Invalid username or password")
                        .foregroundColor(.red)
                }
            }
            .navigationDestination(isPresented: isLoggedIn) {
                BankBalanceView()
            }
        }
    }
}

#Preview {
    LoginView()
}

