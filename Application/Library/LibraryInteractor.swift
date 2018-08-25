import Foundation
import CleanArchitecture
import Catban
import StoreKit
import QRhero

class LibraryInteractor:Interactor, LibraryDelegate, QRViewDelegate {
    weak var delegate:InteractorDelegate?
    let library:Library
    private let report:Report
    
    required init() {
        self.library = Factory.makeLibrary()
        self.report = Report()
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
        let view = QRView()
        view.delegate = self
        view.title = NSLocalizedString("LibraryInteractor.qrView", comment:String())
        Application.router.present(view, animated:true)
    }
    
    func settings() {
        let view:SettingsView = SettingsView()
        Application.router.pushViewController(view, animated:true)
    }
    
    func newBoard() {
        self.library.newBoard()
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
        self.rate()
    }
    
    func makeStats(board:Board) -> ReportStats {
        return self.report.makeStats(board:board)
    }
    
    func qrRead(content:String) {
        do {
            try self.library.addBoard(url:content)
            DispatchQueue.main.async { [weak self] in self?.popupSuccess()  }
        } catch CatbanError.boardAlreadyLoaded {
            self.popup(error:NSLocalizedString("LibraryInteractor.boardDuplicated", comment:String()))
        } catch CatbanError.invalidBoardUrl {
            self.popup(error:NSLocalizedString("LibraryInteractor.invalidQRCode", comment:String()))
        } catch { }
    }
    
    func qrCancelled() {
        Application.router.dismiss(animated:true)
    }
    
    func qrError(error:QRheroError) {
        self.popup(error:NSLocalizedString("LibraryInteractor.scanError", comment:String()))
    }
    
    private func addTemplate(board:Board) {
        board.text = NSLocalizedString("LibraryInteractor.board", comment:String())
        if self.library.defaultColumns {
            board.addColumn(text:NSLocalizedString("LibraryInteractor.column.todo", comment:String()))
            board.addColumn(text:NSLocalizedString("LibraryInteractor.column.progress", comment:String()))
            board.addColumn(text:NSLocalizedString("LibraryInteractor.column.done", comment:String()))
        }
        self.library.save(board:board)
    }
    
    private func rate() {
        if self.library.boards.count > Constants.minBoards {
            if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() }
        }
    }
    
    private func popup(error:String) {
        Application.router.dismiss(animated:true) {
            let popup = Popup()
            popup.image = #imageLiteral(resourceName: "assetError.pdf")
            popup.title = error
        }
    }
    
    private func popupSuccess() {
        Application.router.dismiss(animated:true) {
            let popup = Popup()
            popup.image = #imageLiteral(resourceName: "assetDone.pdf")
            popup.title = NSLocalizedString("LibraryInteractor.boardAdded", comment:String())
        }
    }
}

private struct Constants {
    static let minBoards:Int = 2
}
