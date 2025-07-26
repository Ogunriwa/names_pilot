import Fluent // Imports the Fluent framework, used for database interactions.

// Defines a database migration to create the 'players' table.
struct CreatePlayer: AsyncMigration {
    // The 'prepare' function sets up the database table when the migration is run.
    // - database: The connection to your database.
    // - async throws: Indicates the function is asynchronous and can throw errors.
    func prepare(on database: any Database) async throws {
        // Creates a new table named "players".
        try await database.schema("players")
            .id() // Adds an 'id' column as the primary key.
            .field("game_id", .uuid, .required, .references("games", "id")) // Adds a 'game_id' column that links to the 'games' table.
            .field("username", .string, .required) // Adds a non-empty 'username' column of type String.
            .field("score", .int, .required) // Adds a non-empty 'score' column of type Integer.
            .field("level", .string, .required) // Adds a non-empty 'level' column of type String.
            .field("created_at", .datetime) // Adds a 'created_at' column for the creation timestamp.
            .create() // Executes the table creation.
    }

    // The 'revert' function removes the database table when the migration is undone.
    func revert(on database: any Database) async throws {
        // Deletes the "players" table from the database.
        try await database.schema("players").delete()
    }
}
