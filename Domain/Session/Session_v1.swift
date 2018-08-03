import Foundation

class Session_v1:SessionProtocol, Codable {
    var selected:String?
    var boards:[String]
    
    init() {
        self.boards = []
    }
    
    func current(library:LibraryProtocol) throws -> BoardProtocol {
        guard
            let selected:String = self.selected,
            let board:BoardProtocol = library.boards[selected]
        else { throw DomainError.noBoardSelected }
        return board
    }
    
    func select(identifier:String) {
        self.selected = identifier
    }
    
    func clearSelection() {
        self.selected = nil
    }
}
