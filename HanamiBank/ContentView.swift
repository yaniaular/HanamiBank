//
//  ContentView.swift
//  HanamiBank
//
//  Created by Yanina Aular on 13/03/25.
//

import SwiftUI

struct BackgroundImageView: View {
    var imageName: String
    var body: some View {
        Image(imageName) // Usa la imagen del Assets.xcassets
            .resizable()
            .edgesIgnoringSafeArea(.all) // Ignora los márgenes seguros
            .opacity(0.9) // Ajusta la opacidad si lo deseas
    }
}


struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @State private var navigateToDashboard = false

    // Datos guardados en AppStorage
    @AppStorage(Constants.userIDKey) private var userID: Int?
    @AppStorage(Constants.userNameKey) private var userName: String?
    @AppStorage(Constants.accountIDKey) private var selectedAccountID: Int?

    private var loginService = LoginService()

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImageView(imageName: "background")
                VStack(spacing: 20) {
                    if userID != nil { // Si hay un usuario logueado, mostrar mensaje de bienvenida
                        VStack(spacing: 10) {
                            Text("Buen día \(userName ?? "Usuario")")
                                .font(.title)
                                .bold()
                                .foregroundColor(.blue)
                            
                            // boton para ir al dashboar
                            Button("Ir al Dashboard") {
                                navigateToDashboard = true
                            }
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.green, Color.indigo]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .navigationDestination(isPresented: $navigateToDashboard) {
                                DashboardView()
                            }
                            
                            // boton para cerrar sesión
                            Button("Cerrar Sesión") {
                                loginService.logout(userID: &userID, userName: &userName, accountID: &selectedAccountID)
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    } else {
                        
                        Text("Welcome to HanamiBank!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        
                        // Si no hay usuario logueado, mostrar el formulario de login
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                            .disableAutocorrection(true)
                        
                        Button("Login") {
                            loginService.login(username: username.uppercased(), password: password.lowercased()) { success, user in
                                if success, let user = user {
                                    username = ""
                                    password = ""
                                    userID = user.id
                                    userName = user.username
                                    selectedAccountID = nil
                                    showError = false
                                } else {
                                    showError = true
                                }
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        if showError {
                            Text("Invalid username or password")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
            }
        }
    }

}

#Preview {
    ContentView()
}
