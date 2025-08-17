import Fluent

struct CreateSession: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("sessions")
            .id()
            .field("status", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("sessions")
            .delete()
    }
}
