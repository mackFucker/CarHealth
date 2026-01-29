import SwiftUI

struct UserHomeView: View {
    @StateObject private var cartService = CartService()

    var body: some View {
        TabView {
            ServiceCatalogView()
                .tabItem {
                    Label("Услуги", systemImage: "wrench")
                }
            CartView()
                .tabItem {
                    Label("Корзина", systemImage: "cart")
                }
                .badge(cartService.services.count)
        }
    }
}
