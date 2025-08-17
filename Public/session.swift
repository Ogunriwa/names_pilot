import Vapor

func routes(_ app: Application) throws {
    app.post("sessions") { req -> EventLoopFuture<Session> in
        let session = Session()
        return session.save(on: req.db).map { session }
    }

    app.delete("sessions", ":sessionID") { req -> EventLoopFuture<HTTPStatus> in
        guard let sessionID = req.parameters.get("sessionID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Session.find(sessionID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .noContent)
    }
}
