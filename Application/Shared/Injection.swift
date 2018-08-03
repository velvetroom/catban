import Foundation
import Domain

class Injection {
    class func configure() {
        Configuration.cacheService = CacheService.self
        Configuration.databaseService = DatabaseService.self
    }
    
    private init() { }
}
