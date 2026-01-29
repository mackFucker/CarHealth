import SwiftUI
import SwiftData

struct ServiceCatalogView: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject private var authService: AuthService
    @EnvironmentObject private var cartService: CartService

    @Query(sort: \Service.price) private var services: [Service]

    @State private var showCreate = false
    @State private var searchText = ""

    private var canEdit: Bool {
        let role = authService.currentUser?.role.name
        return role == "Admin" || role == "Manager"
    }

    private var filteredServices: [Service] {
        guard !searchText.isEmpty else {
            return services.filter { $0.isActive }
        }

        return services.filter {
            $0.isActive &&
            (
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.descriptionText.localizedCaseInsensitiveContains(searchText)
            )
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredServices) { service in
                    ServiceRow(service: service)
                }
                .onDelete(perform: canEdit ? delete : nil)
            }
            .navigationTitle("Услуги")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Поиск услуг"
            )
            .toolbar {
                if canEdit {
                    Button {
                        showCreate = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreate) {
                ServiceEditView()
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        offsets.map { services[$0] }.forEach(context.delete)
    }
}
