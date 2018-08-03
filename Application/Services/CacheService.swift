import Foundation
import Domain
import CodableHero

class CacheService:CacheServiceProtocol {
    private let codableHero:CodableHero
    
    required init() {
        self.codableHero = Factory.makeCodableHero()
    }
    
    func load<M>(session:@escaping((M) -> Void), error:@escaping((Error) -> Void)) where M:Codable & SessionProtocol {
        self.codableHero.load(path:Constants.session + Constants.file, completion:session, error:error)
    }
    
    func load<M>(identifier:String, board:@escaping((M) -> Void)) where M:Codable & BoardProtocol {
        self.codableHero.load(path:identifier + Constants.file, completion:board, error:nil)
    }
    
    func save<M>(session:M) where M:Codable & SessionProtocol {
        self.codableHero.save(model:session, path:Constants.session + Constants.file, completion:nil, error:nil)
    }
    
    func save<M>(identifier:String, board:M) where M:Codable & BoardProtocol {
        self.codableHero.save(model:board, path:identifier + Constants.file, completion:nil, error:nil)
    }
}

private struct Constants {
    static let session:String = "Session"
    static let file:String = ".catban"
}
