//
//  SavingSection.swift
//  HanamiBank
//
//  Created by Yanina Aular on 20/03/25.
//

 import SwiftUI

struct SavingsSection: View {
    let savings: [Saving]
    @State private var showAddSaving = false
    @State private var selectedSaving: Saving?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Mis Ahorros")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(action: { showAddSaving = true }) {
                    Image(systemName: "plus")
                }
            }
            .padding(.bottom, 8)
            
            ForEach(savings) { saving in
                SavingCard(saving: saving) {
                    selectedSaving = saving
                }
            }
        }
        .sheet(isPresented: $showAddSaving) {
            AddSavingView()
        }
        .sheet(item: $selectedSaving) { saving in
            ManageSavingView(saving: saving)
        }
    }
}

struct SavingCard: View {
    let saving: Saving
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(saving.name)
                        .font(.headline)
                    Text("Balance: \(saving.amount, specifier: "%.2f")")
                        .font(.subheadline)
                }
                Spacer()
                Button("Gestionar", action: action)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
