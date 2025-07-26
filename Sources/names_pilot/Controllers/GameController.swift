import Vapor // Imports the Vapor framework, which helps in building web applications in Swift.

// This structure defines a group of routes related to the 'Game' model.
// A route is a specific path on your website, like '/games' or '/games/123'.
struct GameController: RouteCollection {
    // This function is called to set up all the routes for games.
    func boot(routes: any RoutesBuilder) throws {
        // Create a group for all routes that start with '/games'.
        let games = routes.grouped("games")
        // When a user sends a GET request to '/games', call the 'index' function.
        games.get(use: index)
        // When a user sends a POST request to '/games', call the 'create' function.
        games.post(use: create)
        // Group routes that have a specific game ID in the path, like '/games/A-B-C-D'.
        games.group(":gameID") { game in
            // When a user sends a DELETE request to '/games/A-B-C-D', call the 'delete' function.
            game.delete(use: delete)
        }
    }

    // This function handles GET requests to '/games'. It returns a list of all games.
    // 'req' is the incoming web request from the user's browser.
    // 'async throws' means this function can run over time (asynchronously) and can report errors.
    func index(req: Request) async throws -> [Game] {
        // This line queries the database for all records in the 'Game' table and returns them.
        try await Game.query(on: req.db).all()
    }

    // This function handles POST requests to '/games'. It creates a new game.
    func create(req: Request) async throws -> Game {
        // Decode the incoming data (like from a web form) into a 'Game' object.
        let game = try req.content.decode(Game.self)
        // Save the new 'Game' object to the database.
        try await game.save(on: req.db)
        // Return the saved game, which now has an ID from the database.
        return game
    }

    // This function handles DELETE requests to '/games/:gameID'. It deletes a specific game.
    func delete(req: Request) async throws -> HTTPStatus {
        // Find the game in the database using the ID from the URL (e.g., 'A-B-C-D').
        guard let game = try await Game.find(req.parameters.get("gameID"), on: req.db) else {
            // If the game is not found, send a '404 Not Found' error.
            throw Abort(.notFound)
        }
        // Delete the found game from the database.
        try await game.delete(on: req.db)
        // Return a '204 No Content' status to indicate success without sending any data back.
        return .noContent
    }
}
