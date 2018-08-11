import Foundation

public protocol LibraryProtocol:AnyObject {
    var delegate:LibraryDelegate? { get set }
    var boards:[String:Board] { get }
    
    func loadBoards() throws
    func loadSession()
    func newBoard()
    func addBoard(identifier:String)
    func save(board:Board)
    func delete(board:Board)
}
