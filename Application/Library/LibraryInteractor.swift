import Foundation
import CleanArchitecture
import Catban
import StoreKit

class LibraryInteractor:Interactor, LibraryDelegate {
    weak var delegate:InteractorDelegate?
    let library:LibraryProtocol
    private let report:ReportProtocol
    
    required init() {
        self.library = Factory.makeLibrary()
        self.report = Factory.makeReport()
        self.library.delegate = self
    }
    
    func load() {
        do {
            try self.library.loadBoards()
        } catch {
            self.library.loadSession()
        }
    }
    
    func scan() {
        let view:ScanView = ScanView(presenter:ScanPresenter())
        view.presenter.interactor = self
        Application.router.pushViewController(view, animated:true)
    }
    
    func duplicated(identifier:String) -> Bool {
        return self.library.boards[identifier] != nil
    }
    
    func newBoard() {
        self.library.newBoard()
    }
    
    func addBoard(identifier:String) {
        self.library.addBoard(identifier:identifier)
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
        if self.library.boards.count > Constants.minBoards {
            if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() }
        }
    }
    
    func makeStats(board:Board) -> ReportStats {
        return self.report.makeStats(board:board)
    }
    
    private func addTemplate(board:Board) {
        board.text = NSLocalizedString("LibraryInteractor.board", comment:String())
        board.addColumn(text:NSLocalizedString("LibraryInteractor.column.todo", comment:String()))
        board.addColumn(text:NSLocalizedString("LibraryInteractor.column.progress", comment:String()))
        board.addColumn(text:NSLocalizedString("LibraryInteractor.column.done", comment:String()))
        self.library.save(board:board)
    }
}

private struct Constants {
    static let minBoards:Int = 2
}
