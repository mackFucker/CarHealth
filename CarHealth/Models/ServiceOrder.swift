import SwiftData
import Foundation

enum OrderStatus: String, Codable {
    case created
    case inProgress
    case completed
    case cancelled
}

@Model
final class ServiceOrder {
    @Attribute(.unique) var id: UUID

    var createdAt: Date
    var status: OrderStatus

    @Relationship
    var car: Car

    @Relationship
    var services: [Service]

    @Relationship
    var customer: User

    init(
        car: Car,
        services: [Service],
        customer: User
    ) {
        self.id = UUID()
        self.createdAt = .now
        self.status = .created
        self.car = car
        self.services = services
        self.customer = customer
    }
}
