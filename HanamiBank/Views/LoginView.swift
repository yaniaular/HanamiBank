import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false

    // Datos guardados en AppStorage
    @AppStorage(Constants.userIDKey) private var userID: Int?
    @AppStorage(Constants.userNameKey) private var userName: String?
    
    private var loginService = LoginService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if userID != nil {                    // Si hay un usuario logueado, mostrar mensaje de bienvenida
                    VStack(spacing: 10) {
                        Text("Buen día \(userName ?? "Usuario")")
                            .font(.title)
                            .bold()
                            .foregroundColor(.blue)

                        // Botón para ir al dashboard
                        NavigationLink(destination: BankBalanceView()) {
                            Text("Ir a tu dashboard")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button("Cerrar Sesión") {
                            loginService.logout(userID: &userID, userName: &userName)
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                } else {
                    // Si no hay usuario logueado, mostrar el formulario de login
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    Button("Login") {
                        loginService.login(username: username, password: password) { success, user in
                            if success, let user = user {
                                userID = user.id
                                userName = user.username
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
            .navigationDestination(isPresented: Binding(
                get: { userID != nil },
                set: { _ in }
            )) {
                BankBalanceView()
            }
        }
    }

}

// Para mostrar el canvas
#Preview {
    LoginView()
}
