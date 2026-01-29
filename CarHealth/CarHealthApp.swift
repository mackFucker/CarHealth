import SwiftUI
import SwiftData

@main
struct CarHealthApp: App {
    var container: ModelContainer = {
        let schema = Schema([
            User.self,
            Role.self,
            Car.self,
            Service.self
        ])
        
        let config = ModelConfiguration(schema: schema)
        return try! ModelContainer(for: schema, configurations: [config])
    }()
    
    var body: some Scene {
        WindowGroup {
            RootView(context: container.mainContext)
                .modelContainer(container)
                .onAppear {
                    let context = container.mainContext
                    AppDataSeeder.seedIfNeeded(context: context)
                }
        }
    }
}

