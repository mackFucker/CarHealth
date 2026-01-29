import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cartService: CartService
    @State private var showSuccessAlert = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(cartService.services) { service in
                    HStack(spacing: 12) {

                        // Image (assets + documents)
                        loadImage(name: service.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipped()
                            .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(service.title)
                                .font(.headline)

                            Text("\(service.price, specifier: "%.0f") ₽")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: cartService.remove)

                if !cartService.services.isEmpty {
                    HStack {
                        Text("Итого")
                            .bold()
                        Spacer()
                        Text("\(cartService.totalPrice, specifier: "%.0f") ₽")
                            .bold()
                    }
                }
            }
            .navigationTitle("Корзина")
            .toolbar {
                Button("Купить") {
                    cartService.clear()
                    showSuccessAlert = true
                }
                .disabled(cartService.services.isEmpty)
            }
            .alert("Успешно 🎉",
                   isPresented: $showSuccessAlert) {
                Button("Ок", role: .cancel) {}
            } message: {
                Text("Заказ успешно оформлен")
            }
        }
    }
}

func loadImage(name: String) -> Image {
    let url = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent(name)

    if let uiImage = UIImage(contentsOfFile: url.path) {
        return Image(uiImage: uiImage)
    } else {
        return Image(name) // asset fallback
    }
}
