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
    @State private var lastUpdate = Date() // Reemplazamos refreshID con este


    // Datos guardados en AppStorage
    @AppStorage(Constants.userIDKey) private var userID: Int?
    @AppStorage(Constants.userNameKey) private var userName: String?
    @AppStorage(Constants.accountIDKey) private var selectedAccountID: Int?

    var body: some View {
        ZStack {
            BackgroundImageView(imageName: "background")
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
                loadData()
            }
            .onReceive(NotificationCenter.default.publisher(for: .shouldRefreshDashboard)) { _ in
                loadData()
            }
            .navigationDestination(isPresented: $navigateToTransaccion) {
                if selectedAccountID != nil {
                    TransactionView()
                }
            }
            .navigationDestination(isPresented: $navigateToViewAccount) {
                if selectedAccountID != nil {
                    AccountView()
                }
            }
            .background(
                Color.clear
                    .onChange(of: lastUpdate) {  // Nueva sintaxis de onChange
                        // No necesitamos hacer nada aquí, solo queremos que la vista reaccione al cambio
                    }
            )
        }
    }
    
    private func loadData() {
        if let userID = userID {
            BankService.shared.getAllAccounts(user_id: userID) { accounts in
                if let accounts = accounts {
                    self.accounts = accounts
                    self.lastUpdate = Date() // Actualizamos el timestamp
                }
            }
            BankService.shared.getAllSavings(user_id: userID) { savings in
                if let savings = savings {
                    self.savings = savings
                    self.lastUpdate = Date() // Actualizamos el timestamp

                }
            }
        }
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
