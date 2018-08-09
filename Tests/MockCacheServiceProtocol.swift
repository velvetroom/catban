import Foundation
@testable import Domain

class MockCacheServiceProtocol:CacheServiceProtocol {
    var error:Error?
    var onSaveSession:(() -> Void)?
    var session:Configuration.Session
    var board:Configuration.Board
    
    required init() {
        self.session = Configuration.Session()
        self.board = Configuration.Board()
    }
    
    func loadSession<M>() throws -> M where M:Codable & SessionProtocol {
        if let error:Error = self.error {
            throw error
        } else {
            return self.session as! M
        }
    }
    
    func save<M>(session:M) where M:Codable & SessionProtocol {
        self.onSaveSession?()
    }
}
