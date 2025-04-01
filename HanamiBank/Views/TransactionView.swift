//
//  TransactionView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 19/03/25.
//

import SwiftUI

struct TransactionView: View {
    @State private var transactions: [Transaction] = [] // Almacena las transacciones
    @State private var isLoading = false // Estado para mostrar un indicador de carga
    @State private var errorMessage: String? // Mensaje de error
    @AppStorage(Constants.accountIDKey) private var selectedAccountID: Int?

    var body: some View {
        ZStack {
            BackgroundImageView(imageName: "background")
            ScrollView {
                if isLoading {
                    ProgressView("Cargando transacciones...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    VStack(spacing: 20) {
                        ForEach(transactions) { transaction in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(transaction.description)
                                    .font(.headline)
                                Text("Monto: \(transaction.amount, specifier: "%.2f")")
                                    .font(.subheadline)
                                Text("Tipo: \(transaction.type)")
                                    .font(.caption)
                                Text("Fecha: \(transaction.created_at)")
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Transacciones")
            .onAppear {
                fetchTransactions()
            }
        }
    }

    private func fetchTransactions() {
        isLoading = true
        errorMessage = nil

        if let accountID = selectedAccountID {
            BankService.shared.getAllTransactions(account_id: accountID) { transactions in
                isLoading = false
                if let transactions = transactions {
                    self.transactions = transactions
                } else {
                    errorMessage = "No se pudieron cargar las transacciones."
                }
            }
        } else {
            errorMessage = "No hay un ID de cuenta seleccionado."
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView() // En los preview se tiene que usar variables de prueba
    }
}
