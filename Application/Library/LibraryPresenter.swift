import Foundation
import CleanArchitecture
import Domain

class LibraryPresenter:Presenter {
    var interactor:LibraryInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    @objc func newBoard() {
        self.viewModels.update(viewModel:LibraryViewModel())
        self.interactor.newBoard()
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
            self.showItems()
        }
    }
    
    private func showEmpty() {
        var viewModel:LibraryViewModel = LibraryViewModel()
        viewModel.message = NSLocalizedString("LibraryPresenter.empty", comment:String())
        viewModel.loadingHidden = true
        viewModel.addEnabled = true
        self.viewModels.update(viewModel:viewModel)
    }
    
    private func showItems() {
        var viewModel:LibraryViewModel = LibraryViewModel()
        viewModel.items = self.items
        viewModel.loadingHidden = true
        viewModel.addEnabled = true
        self.viewModels.update(viewModel:viewModel)
    }
    
    private var items:[LibraryItemViewModel] { get {
        var items:[LibraryItemViewModel] = []
        self.interactor.library.boards.forEach { (key:String, board:BoardProtocol) in
            var item:LibraryItemViewModel = LibraryItemViewModel()
            item.board = key
            item.name = board.name
            items.append(item)
        }
        return items.sorted { (left:LibraryItemViewModel, right:LibraryItemViewModel) -> Bool in
            return left.name.caseInsensitiveCompare(right.name) == ComparisonResult.orderedAscending
        }
    } }
}
