import Foundation

protocol LibraryState:AnyObject {
    func loadBoards(context:Library) throws
    func loadSession(context:Library)
    func newBoard(context:Library) throws
    func addBoard(context:Library, url:String) throws
    func merge(context:Library, boards:[String]) throws
    func change(context:Library, skin:Skin) throws
}
