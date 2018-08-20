import Foundation
import CleanArchitecture
import Catban

class LibraryPresenter:Presenter {
    var interactor:LibraryInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    @objc func newBoard() {
        self.viewModels.update(viewModel:LibraryViewModel())
        self.interactor.newBoard()
    }
    
    @objc func scan() {
        self.interactor.scan()
    }
    
    @objc func settings() {
        self.interactor.settings()
    }
    
    @objc func selected(cell:LibraryCellView) {
        self.interactor.select(identifier:cell.viewModel.board)
    }
    
    @objc func highlight(cell:LibraryCellView) {
        cell.highlight()
    }
    
    @objc func unhighlight(cell:LibraryCellView) {
        cell.unhighlight()
    }
    
    func willAppear() {
        self.viewModels.update(viewModel:LibraryViewModel())
        self.interactor.load()
    }
    
    func shouldUpdate() {
        if self.interactor.library.boards.isEmpty {
            self.showEmpty()
        } else {
            DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async { [weak self] in self?.showItems() }
        }
    }
    
    private func showEmpty() {
        var viewModel:LibraryViewModel = LibraryViewModel()
        viewModel.message = NSLocalizedString("LibraryPresenter.empty", comment:String())
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        self.viewModels.update(viewModel:viewModel)
    }
    
    private func showItems() {
        var viewModel:LibraryViewModel = LibraryViewModel()
        viewModel.items = self.items
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        self.viewModels.update(viewModel:viewModel)
    }
    
    private var items:[LibraryItemViewModel] { get {
        var items:[LibraryItemViewModel] = []
        self.interactor.library.boards.forEach { (key:String, board:Board) in
            var item:LibraryItemViewModel = LibraryItemViewModel()
            item.board = key
            item.name = board.text
            item.progress = self.interactor.makeStats(board:board).progress
            items.append(item)
        }
        return items.sorted { (left:LibraryItemViewModel, right:LibraryItemViewModel) -> Bool in
            return left.name.caseInsensitiveCompare(right.name) == ComparisonResult.orderedAscending
        }
    } }
}
