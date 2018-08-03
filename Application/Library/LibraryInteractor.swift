import Foundation
import CleanArchitecture
import Domain

class LibraryInteractor:Interactor, LibraryDelegate {
    weak var delegate:InteractorDelegate?
    let library:LibraryProtocol
    
    required init() {
        self.library = Factory.makeLibrary()
        self.library.delegate = self
    }
    
    func load() {
        do {
            try self.library.loadBoards()
        } catch {
            do { try self.library.loadSession() } catch { }
        }
    }
    
    func newBoard() {
        do { try self.library.newBoard() } catch { }
    }
    
    func select(identifier:String) {
        let view:BoardView = BoardView()
        view.presenter.interactor.board = self.library.boards[identifier]
        Application.router.pushViewController(view, animated:true)
    }
    
    func librarySessionLoaded() {
        self.load()
    }
    
    func libraryBoardsUpdated() {
        self.delegate?.shouldUpdate()
    }
    
    func libraryCreated(board:String) {
        self.select(identifier:board)
    }
}
