import Foundation
import CleanArchitecture
import Catban
import QRhero
import StoreKit

class LibraryInteractor:Interactor, LibraryDelegate, QRViewDelegate {
    weak var delegate:InteractorDelegate?
    var state:LibraryState = LibraryDefault()
    let library = Factory.makeLibrary()
    private let report = Report()
    
    required init() {
        library.delegate = self
    }
    
    func load() {
        do {
            try library.loadBoards()
        } catch {
            library.loadSession()
        }
    }
    
    func scan() {
        let view = QRView()
        view.delegate = self
        view.title = NSLocalizedString("LibraryInteractor.qrView", comment:String())
        Application.router.present(view, animated:true)
    }
    
    func settings() {
        Application.router.pushViewController(SettingsView(), animated:true)
    }
    
    func newBoard() {
        library.newBoard()
    }
    
    func select(identifier:String) {
        Application.router.pushViewController(board(identifier:identifier), animated:true)
    }
    
    func board(identifier:String) -> BoardView {
        let view = BoardView()
        view.presenter.interactor.identifier = identifier
        view.presenter.interactor.board = library.boards[identifier]
        return view
    }
    
    func librarySessionLoaded() {
        load()
    }
    
    func libraryBoardsUpdated() {
        state.boardsUpdated(context:self)
    }
    
    func libraryCreated(board:String) {
        addTemplate(board:library.boards[board]!)
        select(identifier:board)
        rate()
    }
    
    func makeStats(board:Board) -> ReportStats {
        return report.makeStats(board:board)
    }
    
    func qrRead(content:String) {
        do {
            try library.addBoard(url:content)
            DispatchQueue.main.async { [weak self] in self?.popupSuccess()  }
        } catch CatbanError.boardAlreadyLoaded {
            popup(error:NSLocalizedString("LibraryInteractor.boardDuplicated", comment:String()))
        } catch CatbanError.invalidBoardUrl {
            popup(error:NSLocalizedString("LibraryInteractor.invalidQRCode", comment:String()))
        } catch { }
    }
    
    func qrCancelled() {
        Application.router.dismiss(animated:true)
    }
    
    func qrError(error:QRheroError) {
        popup(error:NSLocalizedString("LibraryInteractor.scanError", comment:String()))
    }
    
    private func addTemplate(board:Board) {
        board.text = NSLocalizedString("LibraryInteractor.board", comment:String())
        if library.defaultColumns {
            board.addColumn(text:NSLocalizedString("LibraryInteractor.column.todo", comment:String()))
            board.addColumn(text:NSLocalizedString("LibraryInteractor.column.progress", comment:String()))
            board.addColumn(text:NSLocalizedString("LibraryInteractor.column.done", comment:String()))
        }
        library.save(board:board)
    }
    
    private func rate() {
        if library.boards.count > 2 {
            if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() }
        }
    }
    
    private func popup(error:String) {
        Application.router.dismiss(animated:true) {
            let popup = Alert()
            popup.image = #imageLiteral(resourceName: "assetError.pdf")
            popup.title = error
        }
    }
    
    private func popupSuccess() {
        Application.router.dismiss(animated:true) {
            let popup = Alert()
            popup.image = #imageLiteral(resourceName: "assetDone.pdf")
            popup.title = NSLocalizedString("LibraryInteractor.boardAdded", comment:String())
        }
    }
}
