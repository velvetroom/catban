import Foundation
@testable import Catban

class MockCache:CacheService {
    var error:Error?
    var onSaveSession:(() -> Void)?
    var session:Session
    var board:Board
    
    required init() {
        self.session = Session()
        self.board = Board()
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
