import Vapor
// TODO import FluentPostgreSQL
import FluentSQLite

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    var userID: User.ID
    
    init(short: String, long: String, userID: User.ID) {
        self.short = short
        self.long = long
        self.userID = userID
    }
    
}

extension Acronym {
    var user: Parent<Acronym, User> {
        return parent(\.userID)
    }
 
    var categories: Siblings<Acronym, Category, AcronymCategoryPivot> {
        return siblings()
    }
}

// TODO extension Acronym: PostgreSQLModel {}
extension Acronym: SQLiteModel {}

extension Acronym: Migration {
    // TODO static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
    static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}

extension Acronym: Content {}
extension Acronym: Parameter {}
