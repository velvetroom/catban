import Foundation
import Domain

class Injection {
    class func configure() {
        Configuration.cache = Cache.self
        Configuration.databaseService = DatabaseService.self
    }
    
    private init() { }
}
