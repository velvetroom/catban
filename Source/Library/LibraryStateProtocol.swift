import Foundation

protocol LibraryStateProtocol:AnyObject {
    func loadSession(context:Library) throws
    func loadBoards(context:Library) throws
    func newBoard(context:Library) throws
    func addBoard(context:Library, identifier:String) throws
    func save(context:Library, board:Board) throws
    func delete(context:Library, board:Board) throws
}
