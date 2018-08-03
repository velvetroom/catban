import Foundation
@testable import Domain

class MockCacheServiceProtocol:CacheServiceProtocol {
    var error:Error?
    var onSaveSession:(() -> Void)?
    var onSaveBoard:(() -> Void)?
    var session:Configuration.Session
    var board:Configuration.Board
    
    required init() {
        self.session = Configuration.Session()
        self.board = Configuration.Board()
    }
    
    func load<M>(session:@escaping((M) -> Void), error:@escaping((Error) -> Void)) where M:Codable & SessionProtocol {
        if let throwingError:Error = self.error {
            error(throwingError)
        } else {
            session(self.session as! M)
        }
    }
    
    func load<M>(identifier:String, board:@escaping((M) -> Void)) where M:Codable & BoardProtocol {
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async { [weak self] in
            board(self?.board as! M)
        }
    }
    
    func save<M>(session:M) where M:Codable & SessionProtocol {
        self.onSaveSession?()
    }
    
    func save<M>(identifier:String, board:M) where M:Codable & BoardProtocol {
        self.onSaveBoard?()
    }
}
