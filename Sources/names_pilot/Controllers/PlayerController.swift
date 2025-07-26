import Vapor // Imports the Vapor framework, which helps in building web applications in Swift.

// This structure defines a group of routes related to the 'Player' model.
// A route is a specific path on your website, like '/players' or '/players/123'.
struct PlayerController: RouteCollection {
    // This function is called to set up all the routes for players.
    func boot(routes: any RoutesBuilder) throws {
        // Create a group for all routes that start with '/players'.
        let players = routes.grouped("players")
        // When a user sends a GET request to '/players', call the 'index' function.
        players.get(use: index)
        // When a user sends a POST request to '/players', call the 'create' function.
        players.post(use: create)
        // Group routes that have a specific player ID in the path, like '/players/A-B-C-D'.
        players.group(":playerID") { player in
            // When a user sends a DELETE request to '/players/A-B-C-D', call the 'delete' function.
            player.delete(use: delete)
        }
    }

    // This function handles GET requests to '/players'. It returns a list of all players.
    // 'req' is the incoming web request from the user's browser.
    // 'async throws' means this function can run over time (asynchronously) and can report errors.
    func index(req: Request) async throws -> [Player] {
        // This line queries the database for all records in the 'Player' table and returns them.
        try await Player.query(on: req.db).all()
    }

    // This function handles POST requests to '/players'. It creates a new player.
    func create(req: Request) async throws -> Player {
        // Decode the incoming data (like from a web form) into a 'Player' object.
        let player = try req.content.decode(Player.self)
        // Save the new 'Player' object to the database.
        try await player.save(on: req.db)
        // Return the saved player, which now has an ID from the database.
        return player
    }

    // This function handles DELETE requests to '/players/:playerID'. It deletes a specific player.
    func delete(req: Request) async throws -> HTTPStatus {
        // Find the player in the database using the ID from the URL (e.g., 'A-B-C-D').
        guard let player = try await Player.find(req.parameters.get("playerID"), on: req.db) else {
            // If the player is not found, send a '404 Not Found' error.
            throw Abort(.notFound)
        }
        // Delete the found player from the database.
        try await player.delete(on: req.db)
        // Return a '204 No Content' status to indicate success without sending any data back.
        return .noContent
    }
}
