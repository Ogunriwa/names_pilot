import Fluent // Imports the Fluent framework for database interactions.
import Vapor   // Imports the Vapor framework for web application functionality.

// Defines a final class named 'Game' that conforms to the Model, Content, and @unchecked Sendable protocols.
final class Game: Model, Content, @unchecked Sendable {
    static let schema = "games" // Sets the database schema name for this model to "games".

    @ID(key: .id) // Defines the ID property, the primary key in the database.
    var id: UUID? // Stores the unique identifier for a game instance.

    @Field(key: "difficulty") // Defines a field property, corresponding to a database column.
    var difficulty: String // Stores the difficulty level of the game.
l
    @Timestamp(key: "created_at", on: .create) // Defines a timestamp that is automatically set on creation.
    var createdAt: Date? // Stores the creation timestamp of the game.

    @Field(key: "timer") // Defines a field property for the model.
    var timer: Int // Stores the game's timer value.

    @Field(key: "sessionID") // Defines a field property for the model.
    var sessionID: String // Stores the session identifier for the game.

    // Relationships
    @Children(for: \.$game) // Defines a one-to-many relationship with the Round model.
    var rounds: [Round] // Stores an array of Round objects associated with this game.

    @Children(for: \.$game) // Defines a one-to-many relationship with the Player model.
    var players: [Player] // Stores an array of Player objects associated with this game.

    init() {} // Defines an empty initializer required by Fluent.

    // Defines a convenience initializer to create a Game instance with specific properties.
    init(id: UUID? = nil, difficulty: String, timer: Int, sessionID: String) {
        self.id = id                         // Assigns the provided id.
        self.difficulty = difficulty         // Assigns the provided difficulty.
        self.timer = timer                   // Assigns the provided timer.
        self.sessionID = sessionID           // Assigns the provided sessionID.
    }
}
