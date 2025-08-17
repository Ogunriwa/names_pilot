import Vapor
import Fluent

enum SessionStatus: String, Codable, CaseIterable {
    case active
    case ended
}

final class Session: Model, Content, @unchecked Sendable {
    static let schema = "sessions"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "status")
    var status: SessionStatus

    init() { 
        self.status = .active
    }

    init(id: UUID? = nil, status: SessionStatus = .active) {
        self.id = id
        self.status = status
    }
}
