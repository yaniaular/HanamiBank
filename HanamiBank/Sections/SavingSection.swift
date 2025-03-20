//
//  SavingSection.swift
//  HanamiBank
//
//  Created by Yanina Aular on 20/03/25.
//

 import SwiftUI

struct SavingsSection: View {
    var savings: [Saving]

    var body: some View {
        Section(header: Text("Savings").font(.title).bold()) {
            ForEach(savings, id: \.id) { saving in
                HStack {
                    VStack(alignment: .leading) {
                        Text(saving.name)
                            .font(.headline)
                        Text("Balance: $\(saving.amount, specifier: "%.2f")")
                            .font(.subheadline)
                    }
                    Spacer()
                    HStack {
                        Button(action: {
                            print("Add to \(saving.name)")
                        }) {
                            Text("Agregar")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            print("Withdraw from \(saving.name)")
                        }) {
                            Text("Retirar")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
}
