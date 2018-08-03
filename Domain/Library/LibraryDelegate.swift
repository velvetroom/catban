import Foundation

public protocol LibraryDelegate:AnyObject {
    func librarySessionLoaded()
    func libraryBoardsUpdated()
    func libraryCreated(board:String)
}

public extension LibraryDelegate {
    func librarySessionLoaded() { }
    func libraryBoardsUpdated() { }
    func libraryCreated(board:String) { }
}
