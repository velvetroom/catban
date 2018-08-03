import Foundation
import Domain

class MockLibraryDelegate:LibraryDelegate {
    var onSessionLoaded:(() -> Void)?
    var onBoardsUpdated:(() -> Void)?
    var onCreated:(() -> Void)?
    
    func librarySessionLoaded() {
        self.onSessionLoaded?()
    }
    
    func libraryBoardsUpdated() {
        self.onBoardsUpdated?()
    }
    
    func libraryCreated(board:String) {
        self.onCreated?()
    }
}
