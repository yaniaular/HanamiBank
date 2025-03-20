//
//  DashboardView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 19/03/25.
//

import SwiftUI

struct DashboardView: View {
    @State private var accounts: [Account] = []
    @State private var savings: [Saving] = []
    @State private var navigateToTransaccion = false
    @State private var navigateToViewAccount = false

    // Datos guardados en AppStorage
    @AppStorage(Constants.userIDKey) private var userID: Int?
    @AppStorage(Constants.userNameKey) private var userName: String?
    @AppStorage(Constants.accountIDKey) private var selectedAccountID: Int?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Sección de cuentas
                AccountsSection(
                    accounts: accounts,
                    navigateToTransaccion: $navigateToTransaccion,
                    navigateToViewAccount: $navigateToViewAccount
                )

                // Sección de ahorros
                SavingsSection(savings: savings)
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .onAppear {
            if let userID = userID {
                BankService.shared.getAllAccounts(user_id: userID) { accounts in
                    if let accounts = accounts {
                        self.accounts = accounts
                    }
                }
                BankService.shared.getAllSavings(user_id: userID) { savings in
                    if let savings = savings {
                        self.savings = savings
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigateToTransaccion) {
            if selectedAccountID != nil {
                TransactionView()
            }
        }
        .navigationDestination(isPresented: $navigateToViewAccount) {
            if let accountID = selectedAccountID {
                // Aquí puedes navegar a la vista de información de la cuenta
                Text("Información de la cuenta \(accountID)")
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
