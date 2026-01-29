import SwiftData
import Foundation
import SwiftUI

@MainActor
final class AuthService: ObservableObject {

    @Published private(set) var currentUser: User?

    @AppStorage("currentUserEmail")
    private var storedEmail: String?

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        restoreSession()
    }

    func login(email: String, password: String) throws {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate {
                $0.email == email && $0.passwordHash == password
            }
        )

        let users = try context.fetch(descriptor)

        guard let user = users.first else {
            throw AuthError.invalidCredentials
        }

        currentUser = user
        storedEmail = user.email // ✅ сохраняем сессию
    }

    func logout() {
        currentUser = nil
        storedEmail = nil // ❌ очищаем сессию
    }

    private func restoreSession() {
        guard let email = storedEmail else { return }

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )

        if let user = try? context.fetch(descriptor).first {
            currentUser = user
        }
    }
}


enum AuthError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        "Неверный логин или пароль"
    }
}
