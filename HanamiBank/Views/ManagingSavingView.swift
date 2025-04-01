//
//  ManagingSavingView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 31/03/25.
//

import SwiftUI

struct ManageSavingView: View {
    let saving: Saving
    @Environment(\.dismiss) var dismiss
    @State private var amount: String = ""
    @State private var selectedAccountId: Int?
    @State private var isDeposit = true
    @State private var accounts: [Account] = []
    @AppStorage(Constants.userIDKey) private var userID: Int?

    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informacion")) {
                    Text(saving.name)
                    Text("Balance actual: \(saving.amount, specifier: "%.2f")")
                }
                
                Picker("Operación", selection: $isDeposit) {
                    Text("Agregar").tag(true)
                    Text("Retirar").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Section(header: Text(isDeposit ? "Agregar fondos" : "Retirar fondos")) {
                    Picker("Cuenta", selection: $selectedAccountId) {
                        ForEach(accounts) { account in
                            Text(account.account_number).tag(account.id as Int?)
                        }
                    }
                    
                    TextField("Monto", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Button(isDeposit ? "Agregar" : "Retirar") {
                    performSavingAction()
                }
                .disabled(amount.isEmpty || selectedAccountId == nil)
            }
            .navigationTitle("Gestionar Ahorro")
            .onAppear {
                if let userId = userID {
                    BankService.shared.getAllAccounts(user_id: userId) { accounts in
                        self.accounts = accounts ?? []
                        self.selectedAccountId = accounts?.first?.id
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
    
    // Cuando le das al boton de agregar o retirar
    private func performSavingAction() {
        guard let accountId = selectedAccountId,
              let amountValue = Double(amount),
              amountValue > 0 else { return }
        
        let action = SavingAction(
            saving_id: saving.id,
            account_id: accountId,
            amount: isDeposit ? amountValue : -amountValue
        )
        
        BankService.shared.manageSaving(action: action) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("""
                    Transacción exitosa:
                    - Mensaje: \(response.message)
                    - Nuevo saldo cuenta: \(response.newAccountBalance)
                    - Nuevo saldo ahorro: \(response.newSavingBalance)
                    """)
                    NotificationCenter.default.post(name: .shouldRefreshDashboard, object: nil)
                    dismiss()
                    
                case .failure(let error):
                    print("Error en la transacción: \(error.localizedDescription)")
                    // Aquí puedes mostrar un alert al usuario
                }
            }
        }
    }
}

/*struct ManageSavingView_Previews: PreviewProvider {
    static var previews: some View {
        ManageSavingView()
    }
}*/
