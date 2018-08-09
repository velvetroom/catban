import Foundation

public protocol LibraryProtocol:AnyObject {
    var delegate:LibraryDelegate? { get set }
    var session:SessionProtocol { get }
    var boards:[String:BoardProtocol] { get }
    
    func loadSession() throws
    func loadBoards() throws
    func newBoard() throws
    func addBoard(identifier:String) throws
    func save(board:BoardProtocol) throws
    func delete(board:BoardProtocol) throws
}
