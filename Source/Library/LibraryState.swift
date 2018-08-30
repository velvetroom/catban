import Foundation

protocol LibraryState:AnyObject {
    func loadBoards(context:Library) throws
    func loadSession(context:Library)
}
