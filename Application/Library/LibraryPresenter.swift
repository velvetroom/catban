import CleanArchitecture
import Catban
import QRhero
import StoreKit

class LibraryPresenter:Presenter, LibraryDelegate, QRViewDelegate {
    var strategy = updateDelegate
    let library = Factory.makeLibrary()
    private let report = Report()
    func makeStats(board:Board) -> ReportStats { return report.makeStats(board:board) }
    func qrCancelled() { Application.navigation.dismiss(animated:true) }
    func qrError(error:QRheroError) { popup(error:NSLocalizedString("LibraryPresenter.scanError", comment:String())) }
    @objc func settings() { Application.navigation.pushViewController(SettingsView(), animated:true) }
    @objc func selected(cell:LibraryCellView) { self.selected(identifier:cell.viewModel.board) }
    @objc func highlight(cell:LibraryCellView) { cell.highlight() }
    @objc func unhighlight(cell:LibraryCellView) { cell.unhighlight() }
    
    func librarySessionLoaded() {
        if let boards = NSUbiquitousKeyValueStore.default.array(forKey:"iturbide.catban.boards") as? [String] {
            try? library.merge(boards:boards)
        } else {
            willAppear()
        }
    }
    
    func libraryBoardsUpdated() {
        strategy(self)()
        strategy = LibraryPresenter.updateDelegate
    }
    
    func libraryCreated(board:String) {
        addTemplate(board:library.boards[board]!)
        if library.boards.count > 2 { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
    }
    
    func qrRead(content:String) {
        do {
            try library.addBoard(url:content)
            DispatchQueue.main.async { [weak self] in self?.popupSuccess()  }
        } catch CatbanError.boardAlreadyLoaded {
            popup(error:NSLocalizedString("LibraryPresenter.boardDuplicated", comment:String()))
        } catch CatbanError.invalidBoardUrl {
            popup(error:NSLocalizedString("LibraryPresenter.invalidQRCode", comment:String()))
        } catch { }
    }
    
    func updateDelegate() {
        NSUbiquitousKeyValueStore.default.set(Array(library.boards.keys), forKey:"iturbide.catban.boards")
        if library.boards.isEmpty {
            showEmpty()
        } else {
            DispatchQueue.global(qos:.background).async { [weak self] in self?.updateItems() }
        }
    }
    
    @objc func newBoard() {
        update(viewModel:LibraryItems())
        try? library.newBoard()
    }
    
    @objc func scan() {
        let view = QRView()
        view.delegate = self
        view.title = NSLocalizedString("LibraryPresenter.qrView", comment:String())
        Application.navigation.present(view, animated:true)
    }
    
    override func willAppear() {
        update(viewModel:LibraryItems())
        library.delegate = self
        do {
            try library.loadBoards()
        } catch {
            library.loadSession()
        }
    }
    
    private func addTemplate(board:Board) {
        board.name = NSLocalizedString("LibraryPresenter.board", comment:String())
        if library.defaultColumns {
            board.addColumn(text:NSLocalizedString("LibraryPresenter.column.todo", comment:String()))
            board.addColumn(text:NSLocalizedString("LibraryPresenter.column.progress", comment:String()))
            board.addColumn(text:NSLocalizedString("LibraryPresenter.column.done", comment:String()))
        }
        library.save(board:board)
    }
    
    private func popup(error:String) {
        Application.navigation.dismiss(animated:true) {
            let popup = Alert()
            popup.image = #imageLiteral(resourceName: "assetError.pdf")
            popup.title = error
        }
    }
    
    private func popupSuccess() {
        Application.navigation.dismiss(animated:true) {
            let popup = Alert()
            popup.image = #imageLiteral(resourceName: "assetDone.pdf")
            popup.title = NSLocalizedString("LibraryPresenter.boardAdded", comment:String())
        }
    }
    
    private func selected(identifier:String) {
        let view = BoardView()
        view.presenter.identifier = identifier
        view.presenter.board = library.boards[identifier]
        Application.navigation.pushViewController(view, animated:true)
    }
    
    private func showEmpty() {
        var viewModel = LibraryItems()
        viewModel.message = NSLocalizedString("LibraryPresenter.empty", comment:String())
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        update(viewModel:viewModel)
    }
    
    private func updateItems() {
        var viewModel = LibraryItems()
        viewModel.items = items
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        Today(items:viewModel.items).store()
        update(viewModel:viewModel)
    }
    
    private var items:[LibraryItem] {
        var items = [LibraryItem]()
        library.boards.forEach { key, board in
            var item = LibraryItem()
            item.board = key
            item.name = board.name
            item.progress = makeStats(board:board).progress
            items.append(item)
        }
        return items.sorted { left, right -> Bool in
            return left.name.caseInsensitiveCompare(right.name) == .orderedAscending
        }
    }
}
