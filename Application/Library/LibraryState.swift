import Foundation

protocol LibraryState:AnyObject {
    func boardsUpdated(context:LibraryInteractor)
}
