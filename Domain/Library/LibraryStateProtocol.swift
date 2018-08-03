import Foundation

protocol LibraryStateProtocol:AnyObject {
    func loadSession(context:Library) throws
    func loadBoards(context:Library) throws
    func newBoard(context:Library) throws
    func saveBoard(context:Library, identifier:String) throws
}
