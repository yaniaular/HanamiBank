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
    @State private var targetAmount: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Nueva Alcancía")) {
                    TextField("Nombre", text: $name)
                    TextField("Monto objetivo", text: $targetAmount)
                        .keyboardType(.decimalPad)
                }
                
                Button("Crear") {
                    // TODO: Lógica para crear nueva alcancía
                    dismiss()
                }
            }
            .navigationTitle("Nuevo Ahorro")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}
