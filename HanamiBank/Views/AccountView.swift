//
//  AccountView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 20/03/25.
//

import SwiftUI

struct AccountView: View {
    @State private var account: Account? // Almacena la informacion de la cuenta
    @State private var isLoading = false // Estado para mostrar un indicador de carga
    @State private var errorMessage: String? // Mensaje de error
    @AppStorage(Constants.accountIDKey) private var selectedAccountID: Int?
    
    var body: some View {
        ZStack {
            BackgroundImageView(imageName: "background")
            ScrollView {
                if isLoading {
                    ProgressView("Cargando la cuenta...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            if let current_account = self.account {
                                Text("Número de cuenta: \(current_account.account_number)")
                                    .font(.subheadline)
                                Text("Created At: \(current_account.created_at)")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                    }
                    .padding()
                }
            }
            .navigationTitle("Cuenta")
            .onAppear {
                fetchAccount()
            }
        }
    }
        
        
        func fetchAccount() {
            isLoading = true
            errorMessage = nil
            
            if let accountID = selectedAccountID {
                BankService.shared.getAccount(account_id: accountID) { result in
                    self.isLoading = false
                    if let account = result {
                        self.account = account
                    } else {
                        errorMessage = "No se pudo cargar la información de la cuenta."
                    }
                }
            } else {
                errorMessage = "No hay un ID de cuenta seleccionado."
            }
        }
}
 
 struct AccountView_Previews: PreviewProvider {
     static var previews: some View {
         AccountView()
     }
 }
