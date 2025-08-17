import Vapor // Imports the Vapor framework, which helps in building web applications in Swift.

// A struct to define the data we will send for validation.
// It conforms to 'Content' so it can be easily converted to/from JSON.
struct RoundValidationRequest: Content {
    let letter: String
    let name: String
    let animal: String
    let place: String
    let object: String
    let sessionID: String
}

// A struct to define the expected response from the validation server.
struct ValidationResponse: Content {
    let isNameCorrect: Bool
    let isAnimalCorrect: Bool
    let isPlaceCorrect: Bool
    let isObjectCorrect: Bool
}


// This structure defines a group of routes related to the 'Round' model.
// A route is a specific path on your website, like '/rounds' or '/rounds/123'.
struct RoundController: RouteCollection {
    // This function is called to set up all the routes for rounds.
    func boot(routes: any RoutesBuilder) throws {
        // Create a group for all routes that start with '/rounds'.
        let rounds = routes.grouped("rounds")
        // When a user sends a GET request to '/rounds', call the 'index' function.
        rounds.get(use: index)
        // When a user sends a POST request to '/rounds', call the 'create' function.
        rounds.post(use: create)
        
        // Group routes that have a specific round ID in the path, like '/rounds/A-B-C-D'.
        rounds.group(":roundID") { round in
            // When a user sends a DELETE request to '/rounds/A-B-C-D', call the 'delete' function.
            round.delete(use: delete)
            // When a user sends a POST request to '/rounds/A-B-C-D/validate', call the 'validate' function.
            round.post("validate", use: validate)
        }
    }

    // This function handles GET requests to '/rounds'. It returns a list of all rounds.
    // 'req' is the incoming web request from the user's browser.
    // 'async throws' means this function can run over time (asynchronously) and can report errors.
    func index(req: Request) async throws -> [Round] {
        // This line queries the database for all records in the 'Round' table and returns them.
        try await Round.query(on: req.db).all()
    }

    // This function handles POST requests to '/rounds'. It creates a new round.
    func create(req: Request) async throws -> Round {
        // Decode the incoming data (like from a web form) into a 'Round' object.
        let round = try req.content.decode(Round.self)
        // Save the new 'Round' object to the database.
        try await round.save(on: req.db)
        // Return the saved round, which now has an ID from the database.
        return round
    }

    // This function handles DELETE requests to '/rounds/:roundID'. It deletes a specific round.
    func delete(req: Request) async throws -> HTTPStatus {
        // Find the round in the database using the ID from the URL (e.g., 'A-B-C-D').
        guard let round = try await Round.find(req.parameters.get("roundID"), on: req.db) else {
            // If the round is not found, send a '404 Not Found' error.
            throw Abort(.notFound)
        }
        // Delete the found round from the database.
        try await round.delete(on: req.db)
        // Return a '204 No Content' status to indicate success without sending any data back.
        return .noContent
    }
    
    // This function handles POST requests to '/rounds/:roundID/validate'.
    // It sends the round's data to an external server for validation.
    func validate(req: Request) async throws -> ValidationResponse {
        // Find the round in the database using the ID from the URL.
        guard let round = try await Round.find(req.parameters.get("roundID"), on: req.db) else {
            // If the round is not found, send a '404 Not Found' error.
            throw Abort(.notFound)
        }

        // Fetch the associated game to get the sessionID
        guard let game = try await Game.find(round.$game.id, on: req.db) else {
            throw Abort(.notFound, reason: "Game not found for this round.")
        }

        // Prepare the data to be sent for validation.
        let validationRequest = RoundValidationRequest(
            letter: round.letter,
            name: round.name,
            animal: round.animal,
            place: round.place,
            object: round.object,
            sessionID: game.sessionID
        )

        // !! IMPORTANT !!
        // Replace this with the actual URL of your validation server.
        let validationURL: URI = "http://your-validation-server.com/validate"

        // Send the data to the external validation server.
        let response = try await req.client.post(validationURL) { clientReq in
            try clientReq.content.encode(validationRequest)
        }
        
        // Decode the response from the validation server into our 'ValidationResponse' struct.
        let validationResponse = try response.content.decode(ValidationResponse.self)
        
        // Return the validation result to the client.
        return validationResponse
    }
}
