import FluentSQLite
import Vapor
import Leaf
import Authentication

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    
    try services.register(FluentSQLiteProvider())
    
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    middlewares.use(SessionsMiddleware.self)
    middlewares.use(FileMiddleware.self)
    services.register(middlewares)
    
    // TODO: commented code for PostgreSQL
    
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
//        }la
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
//    // let database = PostgreSQLDatabase(config: databaseConfig)
//    //  ------>>>>> let database = SQLiteDatabase(storage: .file(path: "db.sqlite")
//    let database = SQLiteDatabase(storage: .memory)
//    // databases.add(database: database, as: .psql)
//    databases.add(database: database, as: .sqlite)
//    services.register(databases)
    
    try services.register(FluentSQLiteProvider())
    var databases = DatabasesConfig()
    try databases.add(database: SQLiteDatabase(storage: .memory), as: .sqlite)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: Acronym.self, database: .sqlite)
    migrations.add(model: Category.self, database: .sqlite)
    migrations.add(model: AcronymCategoryPivot.self, database: .sqlite)
    migrations.add(model: Token.self, database: .sqlite)
    switch env {
    case .development, .testing:
        migrations.add(migration: AdminUser.self, database: .sqlite)
    default:
        break
    }
    migrations.add(migration: AddTwitterURLToUser.self, database: .sqlite)
    // GOT a error on SQLite: "SQLite only supports adding one (1) column in an ALTER query."
    // migrations.add(migration: MakeCategoriesUnique.self, database: .sqlite)
    services.register(migrations)

    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
    
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
