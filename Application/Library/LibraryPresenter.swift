import CleanArchitecture
import Catban
import QRhero
import StoreKit
import MarkdownHero

class LibraryPresenter:Presenter, LibraryDelegate, QRViewDelegate {
    var identifier = String()
    var strategy = updateDelegate
    let library = Factory.makeLibrary()
    private let hero = MarkdownHero.Hero()
    private let report = Report()
    func makeStats(board:Board) -> ReportStats { return report.makeStats(board:board) }
    func qrCancelled() { Application.navigation.dismiss(animated:true) }
    func qrError(error:HeroError) { popup(error:.local("LibraryPresenter.scanError")) }
    func selectBoard() { Application.navigation.pushViewController(board(identifier:identifier), animated:true) }
    @objc func settings() { Application.navigation.pushViewController(SettingsView(), animated:true) }
    @objc func highlight(cell:LibraryCellView) { cell.highlight() }
    @objc func unhighlight(cell:LibraryCellView) { cell.unhighlight() }
    
    func librarySessionLoaded() {
        loadCloud()
    }
    
    func libraryBoardsUpdated() {
        strategy(self)()
        strategy = LibraryPresenter.updateDelegate
    }
    
    func libraryCreated(board:String) {
        addTemplate(board:library.boards[board]!)
        Application.navigation.pushViewController(self.board(identifier:board), animated:true)
        if library.rate() { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
    }
    
    func qrRead(content:String) {
        do {
            try library.addBoard(url:content)
            DispatchQueue.main.async { [weak self] in self?.popupSuccess()  }
        } catch Exception.boardAlreadyLoaded {
            popup(error:.local("LibraryPresenter.boardDuplicated"))
        } catch Exception.invalidBoardUrl {
            popup(error:.local("LibraryPresenter.invalidQRCode"))
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
    
    func board(identifier:String) -> BoardView {
        let view = BoardView()
        view.presenter.identifier = identifier
        view.presenter.board = library.boards[identifier]
        return view
    }
    
    @objc func selected(cell:LibraryCellView) {
        Application.navigation.pushViewController(board(identifier:cell.viewModel.board), animated:true)
    }
    
    @objc func newBoard() {
        update(viewModel:LibraryItems())
        try? library.newBoard()
    }
    
    @objc func scan() {
        let view = QRView()
        view.delegate = self
        view.title = .local("LibraryPresenter.qrView")
        Application.navigation.present(view, animated:true)
    }
    
    @objc func manuallyLoadCloud() {
        update(viewModel:LibraryItems())
        DispatchQueue.global(qos:.background).asyncAfter(deadline:.now() + 10) { [weak self] in    
            self?.loadCloud()
        }
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
        board.name = .local("LibraryPresenter.board")
        if library.defaultColumns {
            board.addColumn(text:.local("LibraryPresenter.column.todo"))
            board.addColumn(text:.local("LibraryPresenter.column.progress"))
            board.addColumn(text:.local("LibraryPresenter.column.done"))
        }
        library.save(board:board)
    }
    
    private func loadCloud() {
        if let boards = NSUbiquitousKeyValueStore.default.array(forKey:"iturbide.catban.boards") as? [String] {
            try? library.merge(boards:boards)
        } else {
            willAppear()
        }
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
            popup.title = .local("LibraryPresenter.boardAdded")
        }
    }
    
    private func showEmpty() {
        var viewModel = LibraryItems()
        viewModel.message = hero.parse(string:.local("LibraryPresenter.empty"))
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        viewModel.loadHidden = false
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
        return library.boards.map { key, board in
            var item = LibraryItem()
            item.board = key
            item.name = board.name
            item.progress = makeStats(board:board).progress
            return item
        }.sorted { left, right in left.name.caseInsensitiveCompare(right.name) == .orderedAscending }
    }
}
