import Foundation

public protocol LibraryDelegate:AnyObject {
    func librarySessionLoaded()
    func libraryBoardsUpdated()
}

public extension LibraryDelegate {
    func librarySessionLoaded() { }
    func libraryBoardsUpdated() { }
}
