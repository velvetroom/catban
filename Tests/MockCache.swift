import Foundation
@testable import Catban

class MockCache:CacheService {
    var error:Error?
    var onSaveSession:(() -> Void)?
    var session = Session()
    var board = Board()
    
    required init() { }
    
    func loadSession() throws -> Session {
        if let error = self.error {
            throw error
        } else {
            return session
        }
    }
    
    func save(session:Session) {
        onSaveSession?()
    }
}
