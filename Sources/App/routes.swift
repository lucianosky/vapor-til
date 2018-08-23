import Vapor
import Fluent

public func routes(_ router: Router) throws {

    router.get("hello") { req in
        return "Hello, world!"
    }
    
    let acronymsController = AcronymsController()
    try router.register(collection: acronymsController)
    
}
