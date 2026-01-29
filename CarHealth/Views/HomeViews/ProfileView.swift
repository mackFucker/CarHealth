import SwiftUI

struct ProfileView: View {

    @EnvironmentObject private var authService: AuthService

    var user: User {
        authService.currentUser!
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Spacer()

                // 👤 Аватар
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)

                // 📄 Инфо
                VStack(spacing: 8) {
                    Text(user.name)
                        .font(.title2)
                        .bold()

                    Text(user.email)
                        .foregroundColor(.secondary)

                    Text(user.phone)
                        .foregroundColor(.secondary)

                    Text("Роль: \(user.role.name)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // 🚪 Выход
                Button(role: .destructive) {
                    authService.logout()
                } label: {
                    Text("Выйти")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Профиль")
        }
    }
}
