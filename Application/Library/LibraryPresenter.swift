import Foundation
import CleanArchitecture
import Catban

class LibraryPresenter:Presenter<LibraryInteractor> {
    @objc func newBoard() {
        update(viewModel:LibraryItems())
        interactor.newBoard()
    }
    
    @objc func scan() {
        interactor.scan()
    }
    
    @objc func settings() {
        interactor.settings()
    }
    
    @objc func selected(cell:LibraryCellView) {
        interactor.select(identifier:cell.viewModel.board)
    }
    
    @objc func highlight(cell:LibraryCellView) {
        cell.highlight()
    }
    
    @objc func unhighlight(cell:LibraryCellView) {
        cell.unhighlight()
    }
    
    override func willAppear() {
        update(viewModel:LibraryItems())
        interactor.load()
    }
    
    override func shouldUpdate() {
        if interactor.library.boards.isEmpty {
            showEmpty()
        } else {
            DispatchQueue.global(qos:.background).async { [weak self] in self?.updateItems() }
        }
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
        interactor.library.boards.forEach { key, board in
            var item = LibraryItem()
            item.board = key
            item.name = board.name
            item.progress = interactor.makeStats(board:board).progress
            items.append(item)
        }
        return items.sorted { left, right -> Bool in
            return left.name.caseInsensitiveCompare(right.name) == .orderedAscending
        }
    }
}
