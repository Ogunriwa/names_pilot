import Fluent // Imports the Fluent framework, used for database interactions.

// Defines a database migration to create the 'rounds' table.
struct CreateRound: AsyncMigration {
    // The 'prepare' function sets up the database table when the migration is run.
    // - database: The connection to your database.
    // - async throws: Indicates the function is asynchronous and can throw errors.
    func prepare(on database: any Database) async throws {
        // Creates a new table named "rounds".
        try await database.schema("rounds")
            .id() // Adds an 'id' column as the primary key.
            .field("game_id", .uuid, .required, .references("games", "id")) // Adds a 'game_id' column that links to the 'games' table.
            .field("player_id", .uuid, .references("players", "id")) // Adds a 'player_id' column that links to the 'players' table.
            .field("letter", .string, .required) // Adds a non-empty 'letter' column of type String.
            .field("name", .string, .required) // Adds a non-empty 'name' column of type String.
            .field("animal", .string, .required) // Adds a non-empty 'animal' column of type String.
            .field("place", .string, .required) // Adds a non-empty 'place' column of type String.
            .field("object", .string, .required) // Adds a non-empty 'object' column of type String.
            .field("created_at", .datetime) // Adds a 'created_at' column for the creation timestamp.
            .create() // Executes the table creation.
    }

    // The 'revert' function removes the database table when the migration is undone.
    func revert(on database: any Database) async throws {
        // Deletes the "rounds" table from the database.
        try await database.schema("rounds").delete()
    }
}
