//
//  AddSavingView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 31/03/25.
//

import SwiftUI

struct AddSavingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Datos del usuario
    @AppStorage(Constants.userIDKey) private var userID: Int?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Nueva Alcancía")) {
                    TextField("Nombre", text: $name)
                    TextField("Monto aporte inicial", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                     Button(action: createSaving) {
                         HStack {
                             Spacer()
                             if isLoading {
                                 ProgressView()
                             } else {
                                 Text("Crear")
                             }
                             Spacer()
                         }
                     }
                     .disabled(isLoading || name.isEmpty || amount.isEmpty)
                 }
             }
             .navigationTitle("Nuevo Ahorro")
             .alert("Error", isPresented: $showError) {
                 Button("OK", role: .cancel) { }
             } message: {
                 Text(errorMessage)
             }
             .toolbar {
                 ToolbarItem(placement: .cancellationAction) {
                     Button("Cancelar") { dismiss() }
                         .disabled(isLoading)
                 }
             }
         }
     }


    private func createSaving() {
        guard let amount2 = Double(amount), amount2 > 0 else {
            errorMessage = "Ingrese un monto válido mayor a cero"
            showError = true
            return
        }
        
        guard userID != nil else {
            errorMessage = "No se pudo identificar al usuario"
            return
        }
        
        isLoading = true
        
        BankService.shared.createSaving(
            name: name,
            amount: amount2
        ) { success in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    // Notificar que se creó una nueva alcancía
                    NotificationCenter.default.post(name: .shouldRefreshDashboard, object: nil)
                    dismiss()
                } else {
                    errorMessage = "No se pudo crear la alcancía. Intente nuevamente."
                    showError = true
                }
            }
        }
    }
}

struct AddSavingView_Previews: PreviewProvider {
    static var previews: some View {
        AddSavingView()
    }
}
