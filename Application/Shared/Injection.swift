import Foundation
import Catban

class Injection {
    class func configure() {
        Configuration.cache = Cache.self
        Configuration.database = Database.self
    }
    
    private init() { }
}
