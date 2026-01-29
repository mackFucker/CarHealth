import Foundation
import SwiftUI

@MainActor
final class CartService: ObservableObject {
    @Published var services: [Service] = []

    var totalPrice: Double {
        services.reduce(0) { $0 + $1.price }
    }

    func add(_ service: Service) {
        services.append(service)
    }

    func remove(at offsets: IndexSet) {
        services.remove(atOffsets: offsets)
    }

    func clear() {
        services.removeAll()
    }
}

extension CartService {
    func contains(_ service: Service) -> Bool {
        services.contains { $0.id == service.id }
    }
}
