import Foundation
@testable import Catban

class MockDatabase:DatabaseService {
    var onLoad:(() -> Void)?
    var onCreate:(() -> Void)?
    var onSave:(() -> Void)?
    var board = Board()
    
    required init() { }
    
    func load(identifier:String, board:@escaping((Board) -> Void), error:@escaping(() -> Void)) {
        onLoad?()
        board(self.board)
    }
    
    func create(board:Board) -> String {
        onCreate?()
        return String()
    }
    
    func save(identifier:String, board:Board) {
        onSave?()
    }
}
