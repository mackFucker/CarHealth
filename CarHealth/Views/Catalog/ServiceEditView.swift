import SwiftUI
import SwiftData
import PhotosUI

struct ServiceEditView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var duration = ""

    // Image picker
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    private let defaultImageName = "1213" // asset fallback

    var body: some View {
        NavigationStack {
            Form {

                // MARK: - Image
                Section("Изображение") {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                                .cornerRadius(12)
                        } else {
                            Image(defaultImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 140)
                        }
                    }
                }

                // MARK: - Main
                Section("Основное") {
                    TextField("Название", text: $title)
                    TextField("Описание", text: $description)
                }

                // MARK: - Params
                Section("Параметры") {
                    TextField("Цена", text: $price)
                        .keyboardType(.decimalPad)

                    TextField("Длительность (мин)", text: $duration)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Новая услуга")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        save()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                guard let newItem else { return }

                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await MainActor.run {
                            selectedImage = image
                        }
                    }
                }
            }
        }
    }

    // MARK: - Save
    private func save() {
        guard
            let priceValue = Double(price),
            let durationValue = Int(duration),
            !title.isEmpty
        else { return }

        let imageName =
            selectedImage.flatMap { saveImageToDocuments($0) }
            ?? defaultImageName

        let service = Service(
            title: title,
            descriptionText: description,
            price: priceValue,
            durationMinutes: durationValue,
            image: imageName
        )

        context.insert(service)
        dismiss()
    }

    // MARK: - File storage
    private func saveImageToDocuments(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }

        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)

        do {
            try data.write(to: url)
            return filename
        } catch {
            print("Ошибка сохранения изображения:", error)
            return nil
        }
    }
}
