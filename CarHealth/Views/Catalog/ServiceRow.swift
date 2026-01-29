import SwiftUI

struct ServiceRow: View {

    let service: Service
    @EnvironmentObject private var cartService: CartService
    var isInCart: Bool {
          cartService.contains(service)
      }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                loadImage(name: service.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(service.title)
                    .font(.headline)

                Text(service.descriptionText)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("⏱ \(service.durationMinutes) мин")
                    .font(.caption2)
            }

            Spacer()

            Text("\(Int(service.price)) ₽")
                .fontWeight(service.price > 2000 ? .bold : .regular)
                .foregroundColor(service.price > 2000 ? .red : .primary)
            
            Button("Купить") {
                cartService.add(service)
            }
            .buttonStyle(.borderedProminent)
            .tint(isInCart ? .gray : .accentColor)

        }
        .padding(.vertical, 6)
    }
}
