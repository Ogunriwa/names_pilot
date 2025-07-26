import Fluent // Imports the Fluent framework for database interactions.
import Vapor   // Imports the Vapor framework for web application functionality.

// Defines a final class named 'Round' that conforms to the Model, Content, and @unchecked Sendable protocols.
final class Round: Model, Content, @unchecked Sendable {
    static let schema = "rounds" // Sets the database schema name for this model to "rounds".

    @ID(key: .id) // Defines the ID property, the primary key in the database.
    var id: UUID? // Stores the unique identifier for a round instance.

    @Parent(key: "game_id") // Defines a many-to-one relationship with the Game model.
    var game: Game // Stores the game this round is associated with.

    @OptionalParent(key: "player_id") // Defines an optional many-to-one relationship with the Player model.
    var player: Player? // Stores the player associated with this round.

    @Field(key: "letter") // Defines a field property for the model.
    var letter: String // Stores the letter for this round.

    @Field(key: "name") // Defines a field property for the model.
    var name: String // Stores the name entered in this round.

    @Field(key: "animal") // Defines a field property for the model.
    var animal: String // Stores the animal entered in this round.

    @Field(key: "place") // Defines a field property for the model.
    var place: String // Stores the place entered in this round.

    @Field(key: "object") // Defines a field property for the model.
    var object: String // Stores the object entered in this round.

    @Timestamp(key: "created_at", on: .create) // Defines a timestamp that is automatically set on creation.
    var createdAt: Date? // Stores the creation timestamp of the round.

    init() {} // Defines an empty initializer required by Fluent.

    // Defines a convenience initializer to create a Round instance with specific properties.
    init(id: UUID? = nil, gameID: UUID, playerID: UUID? = nil, letter: String, name: String, animal: String, place: String, object: String) {
        self.id = id                         // Assigns the provided id.
        self.$game.id = gameID               // Assigns the provided gameID to the game relationship.
        self.$player.id = playerID           // Assigns the provided playerID to the player relationship.
        self.letter = letter                 // Assigns the provided letter.
        self.name = name                     // Assigns the provided name.
        self.animal = animal                 // Assigns the provided animal.
        self.place = place                   // Assigns the provided place.
        self.object = object                 // Assigns the provided object.
    }
}