import Foundation
import Domain
import CodableHero

class CacheService:CacheServiceProtocol {
    private let codableHero:CodableHero
    
    required init() {
        self.codableHero = Factory.makeCodableHero()
    }
    
    func loadSession<M>() throws -> M where M:Codable & SessionProtocol {
        return try self.codableHero.load(path:Constants.session)
    }
    
    func save<M>(session:M) where M:Codable & SessionProtocol {
        do { try self.codableHero.save(model:session, path:Constants.session) } catch { }
    }
}

private struct Constants {
    static let session:String = "Session.catban"
}
