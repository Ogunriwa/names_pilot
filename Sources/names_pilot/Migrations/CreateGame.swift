import Fluent // Imports the Fluent framework, used for database interactions.

// Defines a database migration to create the 'games' table.
struct CreateGame: AsyncMigration {
    // The 'prepare' function sets up the database table when the migration is run.
    // - database: The connection to your database.
    // - async throws: Indicates the function is asynchronous and can throw errors.
    func prepare(on database: any Database) async throws {
        // Creates a new table named "games".
        try await database.schema("games")
            .id() // Adds an 'id' column as the primary key.
            .field("difficulty", .string, .required) // Adds a non-empty 'difficulty' column of type String.
            .field("timer", .int, .required) // Adds a non-empty 'timer' column of type Integer.
            .field("created_at", .datetime) // Adds a 'created_at' column for the creation timestamp.
            .create() // Executes the table creation.
    }

    // The 'revert' function removes the database table when the migration is undone.
    func revert(on database: any Database) async throws {
        // Deletes the "games" table from the database.
        try await database.schema("games").delete()
    }
}
