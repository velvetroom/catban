import Foundation
import Catban

class MockLibraryDelegate:LibraryDelegate {
    var onSessionLoaded:(() -> Void)?
    var onBoardsUpdated:(() -> Void)?
    var onCreated:(() -> Void)?
    
    func librarySessionLoaded() {
        onSessionLoaded?()
    }
    
    func libraryBoardsUpdated() {
        onBoardsUpdated?()
    }
    
    func libraryCreated(board:String) {
        onCreated?()
    }
}
