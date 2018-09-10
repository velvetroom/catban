import Foundation
import Catban
import CodableHero

class Cache:CacheService {
    private let codableHero = CodableHero()
    
    required init() { }
    
    func loadSession() throws -> Session {
        return try codableHero.load(path:"Session.catban")
    }
    
    func save(session:Session) {
        try? codableHero.save(model:session, path:"Session.catban")
    }
}
