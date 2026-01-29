import SwiftUI

struct AdminHomeView: View {
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
            
            
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person")
                }
        }
        .environmentObject(cartService)
    }
}
