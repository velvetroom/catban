import Foundation

class LibraryQuickAdd:LibraryState {
    func boardsUpdated(context:LibraryInteractor) {
        context.state = LibraryDefault()
        context.newBoard()
    }
}
