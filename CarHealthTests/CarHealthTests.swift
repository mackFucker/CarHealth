import XCTest
import SwiftData
@testable import CarHealth

@MainActor
final class AppServicesTests: XCTestCase {

    private var container: ModelContainer!
    private var context: ModelContext!

    // MARK: - Setup

    override func setUp() async throws {
        container = try ModelContainer(
            for: Role.self,
                 User.self,
                 Service.self,
                 Car.self,
                 ServiceOrder.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = ModelContext(container)
    }

    override func tearDown() async throws {
        container = nil
        context = nil
    }

    // MARK: - Seeder Tests

    func testSeederCreatesInitialData() throws {
        AppDataSeeder.seedIfNeeded(context: context)

        let roles = try context.fetch(FetchDescriptor<Role>())
        let users = try context.fetch(FetchDescriptor<User>())
        let services = try context.fetch(FetchDescriptor<Service>())

        XCTAssertEqual(roles.count, 4, "Должно быть создано 4 роли")
        XCTAssertEqual(users.count, 2, "Должно быть создано 2 пользователя")
        XCTAssertFalse(services.isEmpty, "Сервисы должны быть созданы")
    }

    func testSeederDoesNotDuplicateData() throws {
        AppDataSeeder.seedIfNeeded(context: context)
        AppDataSeeder.seedIfNeeded(context: context)

        let roles = try context.fetch(FetchDescriptor<Role>())
        XCTAssertEqual(roles.count, 4, "Seeder не должен дублировать роли")
    }

    // MARK: - AuthService Tests

    func testLoginSuccess() throws {
        AppDataSeeder.seedIfNeeded(context: context)

        let authService = AuthService(context: context)

        XCTAssertNoThrow(
            try authService.login(email: "admin", password: "admin")
        )

        XCTAssertNotNil(authService.currentUser)
        XCTAssertEqual(authService.currentUser?.email, "admin")
    }

    func testLoginFailure() throws {
        AppDataSeeder.seedIfNeeded(context: context)
        let authService = AuthService(context: context)

        XCTAssertThrowsError(
            try authService.login(email: "wrong", password: "wrong")
        ) { error in
            XCTAssertEqual(
                error as? AuthError,
                AuthError.invalidCredentials
            )
        }
    }

    func testLogoutClearsSession() throws {
        AppDataSeeder.seedIfNeeded(context: context)
        let authService = AuthService(context: context)

        try authService.login(email: "user", password: "user")
        authService.logout()

        XCTAssertNil(authService.currentUser)
    }

    func testRestoreSession() throws {
        AppDataSeeder.seedIfNeeded(context: context)

        // логинимся
        var authService: AuthService? = AuthService(context: context)
        try authService?.login(email: "user", password: "user")

        // пересоздаём сервис (симуляция перезапуска)
        authService = AuthService(context: context)

        XCTAssertNotNil(authService?.currentUser)
        XCTAssertEqual(authService?.currentUser?.email, "user")
    }
}
