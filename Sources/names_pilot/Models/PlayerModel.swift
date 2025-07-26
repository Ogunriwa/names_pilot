import Fluent // Imports the Fluent framework for database interactions.
import Vapor   // Imports the Vapor framework for web application functionality.

// Defines a final class named 'Player' that conforms to the Model, Content, and @unchecked Sendable protocols.
final class Player: Model, Content, @unchecked Sendable {
    static let schema = "players" // Sets the database schema name for this model to "players".

    @ID(key: .id) // Defines the ID property, the primary key in the database.
    var id: UUID? // Stores the unique identifier for a player instance.

    @Parent(key: "game_id") // Defines a many-to-one relationship with the Game model.
    var game: Game // Stores the game this player is associated with.

    @Field(key: "username") // Defines a field property for the model.
    var username: String // Stores the player's username.

    @Field(key: "score") // Defines a field property for the model.
    var score: Int // Stores the player's score.

    @Field(key: "level") // Defines a field property for the model.
    var level: String // Stores the player's level.

    @Timestamp(key: "created_at", on: .create) // Defines a timestamp that is automatically set on creation.
    var createdAt: Date? // Stores the creation timestamp of the player.

    // Relationships
    @Children(for: \.$player) // Defines a one-to-many relationship with the Round model.
    var rounds: [Round] // Stores an array of Round objects associated with this player.

    init() {} // Defines an empty initializer required by Fluent.

    // Defines a convenience initializer to create a Player instance with specific properties.
    init(id: UUID? = nil, gameID: UUID, username: String, score: Int = 0, level: String) {
        self.id = id                         // Assigns the provided id.
        self.$game.id = gameID               // Assigns the provided gameID to the game relationship.
        self.username = username             // Assigns the provided username.
        self.score = score                   // Assigns the provided score.
        self.level = level                   // Assigns the provided level.
    }
}