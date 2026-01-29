import SwiftData

@Model
final class User {
    @Attribute(.unique) var email: String
    var name: String
    var phone: String
    var passwordHash: String

    @Relationship var role: Role
    @Relationship(deleteRule: .cascade) var cars: [Car] = []

    init(
        name: String,
        email: String,
        phone: String,
        passwordHash: String,
        role: Role
    ) {
        self.name = name
        self.email = email
        self.phone = phone
        self.passwordHash = passwordHash
        self.role = role
    }
}

extension User {
    var canManageServices: Bool {
        role.name == "manager" || role.name == "admin"
    }

    var canManageUsers: Bool {
        role.name == "admin"
    }
}
