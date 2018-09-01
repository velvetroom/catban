import Foundation

class LibraryStrategy {
    var value = String()
    var boardsUpdated:((LibraryInteractor) -> () -> Void) = LibraryInteractor.updateDelegate
}
