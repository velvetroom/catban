import Foundation

protocol LibraryStateProtocol:AnyObject {
    func loadBoards(context:Library) throws
    func loadSession(context:Library)
    func newBoard(context:Library)
    func addBoard(context:Library, identifier:String)
    func save(context:Library, board:Board)
    func delete(context:Library, board:Board)
}
