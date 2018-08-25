import Foundation

protocol LibraryStateProtocol:AnyObject {
    func loadBoards(context:Library) throws
    func loadSession(context:Library)
    func newBoard(context:Library)
    func addBoard(context:Library, url:String) throws
    func save(context:Library, board:Board)
    func delete(context:Library, board:Board)
}

extension LibraryStateProtocol {
    func loadBoards(context:Library) throws { }
    func loadSession(context:Library) { }
    func newBoard(context:Library) { }
    func addBoard(context:Library, url:String) throws { }
    func save(context:Library, board:Board) { }
    func delete(context:Library, board:Board) { }
}
