import Foundation

public protocol LibraryProtocol:AnyObject {
    var delegate:LibraryDelegate? { get set }
    var session:Session { get }
    var boards:[String:Board] { get }
    
    func loadSession() throws
    func loadBoards() throws
    func newBoard() throws
    func addBoard(identifier:String) throws
    func save(board:Board) throws
    func delete(board:Board) throws
}
