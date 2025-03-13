//
//  BalanceView.swift
//  banca-hanami
//
//  Created by Yanina Aular on 13/03/25.
//

import SwiftUI

struct BalanceView: View {
    @State private var balance: Double?

    var body: some View {
        VStack {
            if let balance = balance {
                Text("Your balance is: $\(balance, specifier: "%.2f")")
                    .font(.largeTitle)
                    .padding()
            } else {
                Text("Loading balance...")
                    .onAppear {
                        BankService.shared.getBalance { fetchedBalance in
                            self.balance = fetchedBalance
                        }
                    }
            }
        }
    }
}
