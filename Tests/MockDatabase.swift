import Foundation
@testable import Domain

class MockDatabase:DatabaseService {
    var error:Error?
    var onLoad:(() -> Void)?
    var onCreate:(() -> Void)?
    var onSave:(() -> Void)?
    var board:Board
    
    required init() {
        self.board = Factory.makeBoard()
    }
    
    func load(identifier:String, board:@escaping((Board) -> Void)) {
        self.onLoad?()
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async { [weak self] in
            if self?.error == nil {
                if let item:Board = self?.board {
                    board(item)
                }
            }
        }
    }
    
    func create(board:Board) -> String {
        self.onCreate?()
        return String()
    }
    
    func save(identifier:String, board:Board) {
        self.onSave?()
    }
}
