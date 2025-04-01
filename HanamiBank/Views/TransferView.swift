//
//  TransferView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 31/03/25.
//
import SwiftUI

struct TransferView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var clabe: String = ""
    @State private var amount: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSuccess = false
    @AppStorage(Constants.accountIDKey) private var selectedAccountID: Int?
    @AppStorage(Constants.accountClabeKey) private var clabeAccount: String?
    @AppStorage(Constants.accountSaldoKey) private var saldoAccount: Double?
    @State private var account: Account?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cuenta origen")) {
                    if let clabe = clabeAccount {
                        Text(clabe)
                            .font(.body.monospaced())
                    }
                }
                Section(header: Text("Saldo")) {
                    if let saldo = saldoAccount {
                        Text(String(format: "%.2f", saldo))
                            .font(.body.monospaced())
                    }
                }
                
                Section(header: Text("Datos de transferencia")) {
                    TextField("CLABE del destinatario", text: $clabe)
                        .keyboardType(.numberPad)
                    
                    TextField("Monto a transferir", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: performTransfer) {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                            } else {
                                Text("Confirmar Transferencia")
                            }
                            Spacer()
                        }
                    }
                    .disabled(isLoading || clabe.isEmpty || amount.isEmpty)
                }
            }
            .navigationTitle("Transferencia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Transferencia exitosa", isPresented: $showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("La transferencia se realizó correctamente")
            }
        }
    }
    
    private func performTransfer() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "Ingrese un monto válido"
            return
        }

        guard let amountValue = Double(amount), let saldo = saldoAccount, amountValue <= saldo else {
            errorMessage = "No tienes suficientes fondos"
            return
        }
        
        guard clabe.count == 9 else {
            errorMessage = "La CLABE debe tener 9 dígitos"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        /*BankService.shared.doTransfer(
            from: sourceAccount.account_number,
            to: clabe,
            amount: amountValue
        ) { success, message in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    showSuccess = true
                } else {
                    errorMessage = message ?? "Error desconocido al transferir"
                }
            }
        }*/
        
        
    }
}

struct TransferView_Previews: PreviewProvider {
    static var previews: some View {
        TransferView()
    }
}
