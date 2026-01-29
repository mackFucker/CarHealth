import SwiftUI
import SwiftData

struct RootView: View {

    @Environment(\.modelContext) private var context
    @StateObject private var authService: AuthService

    init(context: ModelContext) {
        _authService = StateObject(
            wrappedValue: AuthService(context: context)
        )
    }

    var body: some View {
        Group {
            if let user = authService.currentUser {
                switch user.role.name {
                case "Admin":
                    AdminHomeView()
                case "Manager":
                    ManagerHomeView()
                default:
                    UserHomeView()
                }
            } else {
                LoginView()
            }
        }
        .environmentObject(authService)
    }
}
