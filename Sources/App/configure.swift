// TODO import FluentPostgreSQL
import FluentSQLite
import Vapor

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    
    // TODO try services.register(FluentPostgreSQLProvider())
    try services.register(FluentSQLiteProvider())
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
//    var databases = DatabasesConfig()
//    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
//    let username = Environment.get("DATABASE_USER") ?? "vapor"
//
//    let databaseName: String
//    let databasePort: Int
//    if (env == .testing) {
//        databaseName = "vapor-test"
//        if let testPort = Environment.get("DATABASE_PORT") {
//            databasePort = Int(testPort) ?? 5433
//        } else {
//            databasePort = 5433
//        }
//    } else {
//        databaseName = Environment.get("DATABASE_DB") ?? "vapor"
//        databasePort = 5432
//    }
//
//    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
//
//    let databaseConfig = PostgreSQLDatabaseConfig(
//        hostname: hostname,
//        port: databasePort,
//        username: username,
//        database: databaseName,
//        password: password)
//
//
//    // TODO let database = PostgreSQLDatabase(config: databaseConfig)
//    // TODO ------>>>>> let database = SQLiteDatabase(storage: .file(path: "db.sqlite")
//    let database = SQLiteDatabase(storage: .memory)
//    // TODO databases.add(database: database, as: .psql)
//    databases.add(database: database, as: .sqlite)
//    services.register(databases)
    
    try services.register(FluentSQLiteProvider())
    var databases = DatabasesConfig()
    try databases.add(database: SQLiteDatabase(storage: .memory), as: .sqlite)
    services.register(databases)
    
    var migrations = MigrationConfig()
    // TODO .psql 4x abaixo
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: Acronym.self, database: .sqlite)
    migrations.add(model: Category.self, database: .sqlite)
    migrations.add(model: AcronymCategoryPivot.self, database: .sqlite)
    services.register(migrations)
    
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}
