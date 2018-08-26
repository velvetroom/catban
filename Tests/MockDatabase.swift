import Foundation
@testable import Catban

class MockDatabase:DatabaseService {
    var error:Error?
    var onLoad:(() -> Void)?
    var onCreate:(() -> Void)?
    var onSave:(() -> Void)?
    var board:Board
    
    required init() {
        board = Board()
    }
    
    func load(identifier:String, board:@escaping((Board) -> Void), error:@escaping(() -> Void)) {
        onLoad?()
        DispatchQueue.global(qos:.background).async { [weak self] in
            if self?.error == nil {
                if let item = self?.board {
                    board(item)
                }
            }
        }
    }
    
    func create(board:Board) -> String {
        onCreate?()
        return String()
    }
    
    func save(identifier:String, board:Board) {
        onSave?()
    }
}
