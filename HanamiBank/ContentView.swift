//
//  ContentView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 13/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to HanamiBank!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                NavigationLink(destination: LoginView()) {
                    Text("Go to Login")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
