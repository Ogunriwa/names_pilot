import Vapor

struct SessionController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let sessions = routes.grouped("sessions")
        sessions.post(use: create)
        sessions.group(":sessionID") { session in
            session.post("end", use: end)
        }
    }

    func create(req: Request) async throws -> Session {
        let session = Session()
        try await session.save(on: req.db)
        return session
    }

    func end(req: Request) async throws -> HTTPStatus {
        guard let session = try await Session.find(req.parameters.get("sessionID"), on: req.db) else {
            throw Abort(.notFound)
        }
        session.status = .ended
        try await session.update(on: req.db)
        return .ok
    }
}
