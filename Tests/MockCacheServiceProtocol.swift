import Foundation
@testable import Domain

class MockCacheServiceProtocol:CacheServiceProtocol {
    var error:Error?
    var onSaveSession:(() -> Void)?
    var session:Session
    var board:Board
    
    required init() {
        self.session = Factory.makeSession()
        self.board = Factory.makeBoard()
    }
    
    func loadSession() throws -> Session {
        if let error:Error = self.error {
            throw error
        } else {
            return self.session
        }
    }
    
    func save(session:Session) {
        self.onSaveSession?()
    }
}
