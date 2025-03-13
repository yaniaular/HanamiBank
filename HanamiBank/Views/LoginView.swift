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
    @State private var isLoggedIn = false
    @State private var showError = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)

                Button("Login") {
                    BankService.shared.login(username: username, password: password) { success in
                        if success {
                            isLoggedIn = true
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

                NavigationLink("", destination: BalanceView(), isActive: $isLoggedIn)
            }
        }
    }
}
