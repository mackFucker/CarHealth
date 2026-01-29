import SwiftUI
import SwiftData

enum AuthMode {
    case login
    case register
}

struct LoginView: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject private var authService: AuthService

    @State private var mode: AuthMode = .login

    // login
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    // register
    @State private var name = ""
    @State private var phone = ""

    @Query private var roles: [Role]

    var body: some View {
        VStack(spacing: 24) {

            Text("CarHealth")
                .font(.largeTitle)
                .bold()
            
            // 🔘 Переключатель как на скрине
            Picker("", selection: $mode) {
                Text("Вход").tag(AuthMode.login)
                Text("Регистрация").tag(AuthMode.register)
            }
            .pickerStyle(.segmented)

            Spacer()

            // 🧾 Контент
            Group {
                if mode == .login {
                    loginForm
                } else {
                    registerForm
                }
            }
            .animation(.easeInOut, value: mode)

            Spacer()
        }
        .padding()
    }
}

private extension LoginView {

    var loginForm: some View {
        VStack(spacing: 20) {

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)

            SecureField("Пароль", text: $password)
                .textFieldStyle(.roundedBorder)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Войти") {
                login()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    func login() {
        do {
            try authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private extension LoginView {

    var registerForm: some View {
        VStack(spacing: 20) {

            TextField("Имя", text: $name)
                .textFieldStyle(.roundedBorder)

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)

            TextField("Телефон", text: $phone)
                .textFieldStyle(.roundedBorder)

            SecureField("Пароль", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Зарегистрироваться") {
                register()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    func register() {
        guard
            !name.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            let userRole = roles.first(where: { $0.name == "User" })
        else {
            errorMessage = "Заполните все поля"
            return
        }

        let user = User(
            name: name,
            email: email,
            phone: phone,
            passwordHash: password,
            role: userRole
        )

        context.insert(user)

        // UX: сразу логиним
        do {
            try authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
