import Fluent

struct AddSessionIDToGame: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("games")
            .field("sessionID", .string)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("games")
            .deleteField("sessionID")
            .update()
    }
}
