// TODO import FluentPostgreSQL
import FluentSQLite
import Foundation

// TODO final class AcronymCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot {
final class AcronymCategoryPivot: SQLiteUUIDPivot, ModifiablePivot {

    var id: UUID?

    var acronymID: Acronym.ID
    var categoryID: Category.ID

    typealias Left = Acronym
    typealias Right = Category

    static let leftIDKey: LeftIDKey = \.acronymID
    static let rightIDKey: RightIDKey = \.categoryID

    init(_ acronym: Acronym, _ category: Category) throws {
        self.acronymID = try acronym.requireID()
        self.categoryID = try category.requireID()
    }
}

extension AcronymCategoryPivot: Migration {

    // TODO static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
    static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.acronymID, to: \Acronym.id, onDelete: .cascade)
            builder.reference(from: \.categoryID, to: \Category.id, onDelete: .cascade)
        }
    }
}
