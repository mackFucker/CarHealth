import SwiftData

@Model
final class Role {
    @Attribute(.unique) var name: String

    init(name: String) {
        self.name = name
    }
}
