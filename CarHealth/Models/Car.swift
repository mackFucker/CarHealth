import SwiftData
import Foundation

@Model
final class Car {
    @Attribute(.unique) var id: UUID
    var brand: String
    var model: String
    var year: Int
    var licensePlate: String

    @Relationship(deleteRule: .cascade)
    var owner: User

    init(
        brand: String,
        model: String,
        year: Int,
        licensePlate: String,
        owner: User
    ) {
        self.id = UUID()
        self.brand = brand
        self.model = model
        self.year = year
        self.licensePlate = licensePlate
        self.owner = owner
    }
}
