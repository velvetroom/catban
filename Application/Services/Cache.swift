import Foundation
import Catban
import CodableHero

class Cache:CacheService {
    private let hero = Hero()
    required init() { }
    func loadSession() throws -> Session { return try hero.load(path:"Session.catban") }
    func save(session:Session) { try? hero.save(model:session, path:"Session.catban") }
}
