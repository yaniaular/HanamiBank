//
//  BalanceView.swift
//  banca-hanami
//
//  Created by Yanina Aular on 13/03/25.
//

import SwiftUI

struct BankBalanceView: View {
    @State private var accounts: [Account] = [] // User's account with balance
    @AppStorage(Constants.userIDKey) private var userID: Int? // Acceder al user_id guardado

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Accounts Section
                Section(header: Text("Accounts").font(.title).bold()) {
                    ForEach(accounts) { account in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Account Number: \(account.account_number)")
                                .font(.headline)
                            Text("Balance: $\(account.balance, specifier: "%.2f")")
                                .font(.title2)
                
                            HStack {
                                Button(action: {
                                    // Navegar a transacciones
                                    print("Go to Transactions for Account \(account.id)")
                                }) {
                                    Text("View Transactions")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    // Navegar a la información de la cuenta
                                    print("Go to Account Information for Account \(account.id)")
                                }) {
                                    Text("View Account Info")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.purple)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }

                Spacer()

                // Savings Section
                /*Section(header: Text("Savings").font(.title).bold()) {
                    ForEach(savings, id: \.id) { saving in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(saving.name)
                                    .font(.headline)
                                Text("Balance: $\(saving.amount, specifier: "%.2f")")
                                    .font(.subheadline)
                            }
                            Spacer()
                            HStack {
                                Button(action: {
                                    // Handle Add action
                                    // print("Add to \(saving.name)")
                                }) {
                                    Text("Agregar")
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }

                                Button(action: {
                                    // Handle Withdraw action
                                    // print("Withdraw from \(saving.name)")
                                }) {
                                    Text("Retirar")
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }*/
            }
            .padding()
            .onAppear {
                if let userID = userID {
                    BankService.shared.getAllAccounts(user_id: userID) { accounts in
                        if let accounts = accounts {
                            self.accounts = accounts
                        }
                    }
                }
            }
        }
    }

}

struct BankBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BankBalanceView()
    }
}
