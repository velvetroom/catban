import Foundation

class LibraryQuickScan:LibraryState {
    func boardsUpdated(context:LibraryInteractor) {
        context.state = LibraryDefault()
        context.scan()
    }
}
