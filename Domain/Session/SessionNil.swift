import Foundation

class SessionNil:SessionProtocol {
    var boards:[String]
    
    init() {
        self.boards = []
    }
    
    func current(library:LibraryProtocol) throws -> BoardProtocol { throw DomainError.noSession }
    func select(identifier:String) { }
    func clearSelection() { }
}
