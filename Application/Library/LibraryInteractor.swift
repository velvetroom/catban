import Foundation
import CleanArchitecture
import Catban
import StoreKit

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
        Application.router.pushViewController(view, animated:true)
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
        self.addTemplate(board:self.library.boards[board]!)
        self.select(identifier:board)
        if self.library.session.boards.count > Constants.minBoards {
            if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() }
        }
    }
    
    private func addTemplate(board:Board) {
        let todo:Column = Factory.makeColumn()
        todo.text = NSLocalizedString("LibraryInteractor.column.todo", comment:String())
        let progress:Column = Factory.makeColumn()
        progress.text = NSLocalizedString("LibraryInteractor.column.progress", comment:String())
        let done:Column = Factory.makeColumn()
        done.text = NSLocalizedString("LibraryInteractor.column.done", comment:String())
        board.text = NSLocalizedString("LibraryInteractor.board", comment:String())
        board.columns = [todo, progress, done]
        do { try self.library.save(board:board) } catch { }
    }
}

private struct Constants {
    static let minBoards:Int = 2
}
