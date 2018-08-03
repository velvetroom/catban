import Foundation
import Domain

class MockLibraryDelegate:LibraryDelegate {
    var onSessionLoaded:(() -> Void)?
    var onBoardsUpdated:(() -> Void)?
    
    func librarySessionLoaded() {
        self.onSessionLoaded?()
    }
    
    func libraryBoardsUpdated() {
        self.onBoardsUpdated?()
    }
}
