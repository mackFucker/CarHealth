import SwiftData
import Foundation

@Model
final class Service {
    @Attribute(.unique) var id: UUID
    var title: String
    var descriptionText: String
    var price: Double
    var durationMinutes: Int
    var isActive: Bool
    var image: String

    init(
        title: String,
        descriptionText: String,
        price: Double,
        durationMinutes: Int,
        isActive: Bool = true,
        image: String
    ) {
        self.id = UUID()
        self.title = title
        self.descriptionText = descriptionText
        self.price = price
        self.durationMinutes = durationMinutes
        self.isActive = isActive
        self.image = image
    }
}
