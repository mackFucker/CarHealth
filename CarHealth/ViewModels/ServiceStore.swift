import SwiftData
import Foundation

@MainActor
final class ServiceStore: ObservableObject {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [Service] {
        let descriptor = FetchDescriptor<Service>(
            sortBy: [.init(\.price, order: .forward)]
        )
        return try context.fetch(descriptor)
    }

    func add(service: Service) {
        context.insert(service)
    }

    func delete(service: Service) {
        context.delete(service)
    }
}
