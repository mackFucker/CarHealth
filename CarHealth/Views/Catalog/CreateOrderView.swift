import SwiftUI
import SwiftData

struct CreateOrderView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authService: AuthService

    @Query private var cars: [Car]
    @Query private var services: [Service]

    @State private var selectedCar: Car?
    @State private var selectedServices: Set<Service> = []

    var body: some View {
        NavigationStack {
            Form {
                Section("Автомобиль") {
                    Picker("Выберите авто", selection: $selectedCar) {
                        ForEach(cars.filter { $0.owner.id == authService.currentUser?.id }) {
                            Text("\($0.brand) \($0.model) \($0.licensePlate)")
                                .tag(Optional($0))
                        }
                    }
                }

                Section("Услуги") {
                    ForEach(services) { service in
                        MultipleSelectionRow(
                            title: service.title,
                            isSelected: selectedServices.contains(service)
                        ) {
                            toggle(service)
                        }
                    }
                }
            }
            .navigationTitle("Запись в сервис")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Создать") {
                        createOrder()
                    }
                    .disabled(selectedCar == nil || selectedServices.isEmpty)
                }
            }
        }
    }

    private func toggle(_ service: Service) {
        if selectedServices.contains(service) {
            selectedServices.remove(service)
        } else {
            selectedServices.insert(service)
        }
    }

    private func createOrder() {
        guard
            let car = selectedCar,
            let user = authService.currentUser
        else { return }

        let order = ServiceOrder(
            car: car,
            services: Array(selectedServices),
            customer: user
        )

        context.insert(order)
        dismiss()
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
