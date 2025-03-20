//
//  AccountSection.swift
//  HanamiBank
//
//  Created by Yanina Aular on 20/03/25.
//

import SwiftUI

struct AccountsSection: View {
    var accounts: [Account]
    @Binding var navigateToTransaccion: Bool
    @Binding var navigateToViewAccount: Bool
    
    @AppStorage(Constants.accountIDKey) private var selectedAccountID: Int?

    var body: some View {
        Section(header: Text("Accounts").font(.title).bold()) {
            ForEach(accounts) { account in
                VStack(alignment: .leading, spacing: 10) {
                    Text("Account Number: \(account.account_number)")
                        .font(.headline)
                    Text("Balance: $\(account.balance, specifier: "%.2f")")
                        .font(.title2)

                    HStack {
                        // Botón para ver transacciones
                        Button("Ver Transacciones") {
                            selectedAccountID = account.id
                            navigateToTransaccion = true
                        }
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.green, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

                        // Botón para ver la información de la cuenta
                        Button("Información de la cuenta") {
                            selectedAccountID = account.id
                            navigateToViewAccount = true
                        }
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
}
