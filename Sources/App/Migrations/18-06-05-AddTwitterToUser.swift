import FluentSQLite
import Vapor

struct AddTwitterURLToUser: Migration {
    
    typealias Database = SQLiteDatabase
    
    static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.update(User.self, on: connection) { builder in
            builder.field(for: \.twitterURL)
        }
    }
    
    static func revert(on connection: SQLiteConnection) -> Future<Void> {
        return Database.update( User.self, on: connection) { builder in
            builder.deleteField(for: \.twitterURL)
        }
    }
}
