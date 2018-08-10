import Foundation
import Domain

class Injection {
    class func configure() {
        Configuration.cache = Cache.self
        Configuration.database = Database.self
    }
    
    private init() { }
}
