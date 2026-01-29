import SwiftUI
import SwiftData

struct OrdersListView: View {

    @EnvironmentObject private var authService: AuthService
    @Query private var orders: [ServiceOrder]

    var body: some View {
        List {
            ForEach(userOrders) { order in
                VStack(alignment: .leading) {
                    Text(order.car.brand + " " + order.car.model)
                        .font(.headline)

                    Text("Статус: \(order.status.rawValue)")
                        .font(.caption)

                    Text("Услуг: \(order.services.count)")
                        .font(.caption2)
                }
            }
        }
        .navigationTitle("Мои записи")
    }

    private var userOrders: [ServiceOrder] {
        guard let user = authService.currentUser else { return [] }
        return orders.filter { $0.customer.id == user.id }
    }
}
