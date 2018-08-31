import Foundation

class LibraryDefault:LibraryState {
    func boardsUpdated(context:LibraryInteractor) {
        context.delegate?.shouldUpdate()
    }
}
