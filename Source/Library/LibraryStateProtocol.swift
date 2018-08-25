import Foundation

protocol LibraryStateProtocol:AnyObject {
    func loadBoards(context:Library) throws
    func loadSession(context:Library)
}
