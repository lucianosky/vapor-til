import Foundation
import Vapor
// TODO import FluentPostgreSQL
import FluentSQLite

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User {
    var acronyms: Children<User, Acronym> {
        return children(\.userID)
    }
}

// TODO extension User: PostgreSQLUUIDModel {}
extension User: SQLiteUUIDModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}
