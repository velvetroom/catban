import Foundation
@testable import Domain

class MockDatabaseServiceProtocol:DatabaseServiceProtocol {
    var error:Error?
    var onLoad:(() -> Void)?
    var onCreate:(() -> Void)?
    var board:Configuration.Board
    
    required init() {
        self.board = Configuration.Board()
    }
    
    func load<M>(identifier:String, board:@escaping((M) -> Void)) where M:Codable & BoardProtocol {
        self.onLoad?()
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async { [weak self] in
            if self?.error == nil {
                board(self?.board as! M)
            }
        }
    }
    
    func create<M>(board:M, completion:@escaping((String) -> Void)) where M:Codable & BoardProtocol {
        self.onCreate?()
        completion(String())
    }
}
