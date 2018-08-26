import Foundation
import CleanArchitecture
import Catban

class LibraryPresenter:Presenter {
    var interactor:LibraryInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    @objc func newBoard() {
        viewModels.update(viewModel:LibraryViewModel())
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
    
    func willAppear() {
        viewModels.update(viewModel:LibraryViewModel())
        interactor.load()
    }
    
    func shouldUpdate() {
        if interactor.library.boards.isEmpty {
            showEmpty()
        } else {
            DispatchQueue.global(qos:.background).async { [weak self] in self?.showItems() }
        }
    }
    
    private func showEmpty() {
        var viewModel = LibraryViewModel()
        viewModel.message = NSLocalizedString("LibraryPresenter.empty", comment:String())
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        viewModels.update(viewModel:viewModel)
    }
    
    private func showItems() {
        var viewModel = LibraryViewModel()
        viewModel.items = self.items
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        viewModels.update(viewModel:viewModel)
    }
    
    private var items:[LibraryItemViewModel] {
        var items:[LibraryItemViewModel] = []
        interactor.library.boards.forEach { (key, board) in
            var item = LibraryItemViewModel()
            item.board = key
            item.name = board.text
            item.progress = interactor.makeStats(board:board).progress
            items.append(item)
        }
        return items.sorted { (left, right) -> Bool in
            return left.name.caseInsensitiveCompare(right.name) == .orderedAscending
        }
    } 
}
