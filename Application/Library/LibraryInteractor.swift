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
    
    func scan() {
        let presenter:ScanPresenter = ScanPresenter()
        let view:ScanView = ScanView(presenter:presenter)
        presenter.interactor = self
        Application.router.present(view, animated:true, completion:nil)
    }
    
    func duplicated(identifier:String) -> Bool {
        return self.library.session.boards.contains(identifier)
    }
    
    func newBoard() {
        do { try self.library.newBoard() } catch { }
    }
    
    func addBoard(identifier:String) {
        do { try self.library.addBoard(identifier:identifier) } catch { }
    }
    
    func select(identifier:String) {
        let view:BoardView = BoardView()
        view.presenter.interactor.identifier = identifier
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
