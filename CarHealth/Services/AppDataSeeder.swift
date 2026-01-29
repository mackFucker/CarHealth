import SwiftData

@MainActor
final class AppDataSeeder {

    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Role>()
        let roles = (try? context.fetch(descriptor)) ?? []

        guard roles.isEmpty else { return }

        let guest = Role(name: "Guest")
        let user = Role(name: "User")
        let manager = Role(name: "Manager")
        let admin = Role(name: "Admin")

        context.insert(guest)
        context.insert(user)
        context.insert(manager)
        context.insert(admin)

        let adminUser = User(
            name: "admin",
            email: "admin",
            phone: "+79999999999",
            passwordHash: "admin",
            role: admin
        )

        let testUser = User(
            name: "user",
            email: "user",
            phone: "+79999999999",
            passwordHash: "user",
            role: user
        )

        [
            Service(
                title: "Замена масла",
                descriptionText: "Замена моторного масла и масляного фильтра",
                price: 2500,
                durationMinutes: 40,
                image: "oil_change"
            ),
            
            Service(
                title: "Диагностика двигателя",
                descriptionText: "Компьютерная диагностика двигателя и систем автомобиля",
                price: 2000,
                durationMinutes: 30,
                image: "engine_diagnostics"
            ),
            
            Service(
                title: "Замена тормозных колодок",
                descriptionText: "Замена передних или задних тормозных колодок",
                price: 4500,
                durationMinutes: 60,
                image: "brake_pads"
            ),
            
            Service(
                title: "Развал-схождение",
                descriptionText: "Регулировка углов установки колес",
                price: 3000,
                durationMinutes: 50,
                image: "wheel_alignment"
            ),
            
            Service(
                title: "Шиномонтаж",
                descriptionText: "Снятие, установка и балансировка колес",
                price: 3500,
                durationMinutes: 45,
                image: "tire_service"
            ),
            
            Service(
                title: "Замена аккумулятора",
                descriptionText: "Снятие старого и установка нового аккумулятора",
                price: 1500,
                durationMinutes: 20,
                image: "battery_replacement"
            ),
            
            Service(
                title: "Мойка двигателя",
                descriptionText: "Безопасная мойка двигателя с защитой электроники",
                price: 3000,
                durationMinutes: 40,
                image: "engine_wash"
            )
        ].forEach {
            context.insert($0)
        }

        context.insert(adminUser)
        context.insert(testUser)
    }
}
