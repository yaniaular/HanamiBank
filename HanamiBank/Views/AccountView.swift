//
//  AccountView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 20/03/25.
//

import SwiftUI

struct AccountView: View {
    @State private var account: Account?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @AppStorage(Constants.accountIDKey) private var selectedAccountID: Int?
    @State private var showCopiedAlert = false // Nuevo estado para el feedback
    
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
                                VStack(alignment: .leading, spacing: 16) {
                                    // Header con icono
                                    HStack {
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                        Text("Información de la Cuenta")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }
                                    .padding(.bottom, 8)
                                    
                                    // Tarjeta de información
                                    VStack(alignment: .leading, spacing: 12) {
                                        // Número de cuenta con botón de copiar MEJORADO
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("NÚMERO DE CUENTA")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                Text(current_account.account_number)
                                                    .font(.body.monospaced())
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                copyToClipboard(current_account.account_number)
                                            }) {
                                                Image(systemName: "doc.on.doc")
                                                    .font(.body)
                                                    .foregroundColor(.blue)
                                            }
                                            .buttonStyle(.plain)
                                            .padding(8)
                                            .background(Color.blue.opacity(0.1))
                                            .clipShape(Circle())
                                        }
                                        
                                        Divider()
                                        
                                        // Fecha de creación
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("FECHA DE CREACIÓN")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Text(formatDate(current_account.created_at))
                                                .font(.subheadline)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                }
                                .padding()
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
            // Alerta de copiado
            .alert("Copiado", isPresented: $showCopiedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("El número de cuenta ha sido copiado al portapapeles")
            }
        }
    }
    
    // Función para copiar al portapapeles
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        showCopiedAlert = true
        
        // Para el Canvas de Xcode (solo en modo preview)
        #if DEBUG
        print("Número copiado al portapapeles: \(text)")
        #endif
    }
    
    // ... (resto de tus funciones permanecen igual)
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .long
            outputFormatter.timeStyle = .none
            outputFormatter.locale = Locale(identifier: "es_MX")
            return outputFormatter.string(from: date)
        }
        return dateString
    }
    
    private func fetchAccount() {
        isLoading = true
        errorMessage = nil
        
        if let accountID = selectedAccountID {
            BankService.shared.getAccount(account_id: accountID) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let account = result {
                        self.account = account
                    } else {
                        self.errorMessage = "No se pudo cargar la información de la cuenta."
                    }
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
