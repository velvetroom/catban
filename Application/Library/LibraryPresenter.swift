import Foundation
import CleanArchitecture
import Catban

class LibraryPresenter:Presenter {
    var interactor:LibraryInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    @objc func newBoard() {
        viewModels.update(viewModel:LibraryItems())
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
    
    func didLoad() {
        UIApplication.shared.shortcutItems = []
    }
    
    func willAppear() {
        viewModels.update(viewModel:LibraryItems())
        interactor.load()
    }
    
    func shouldUpdate() {
        if interactor.library.boards.isEmpty {
            showEmpty()
        } else {
            DispatchQueue.global(qos:.background).async { [weak self] in self?.showItems() }
        }
        DispatchQueue.global(qos:.background).async { [weak self] in self?.registerShortcuts() }
    }
    
    private func showEmpty() {
        var viewModel = LibraryItems()
        viewModel.message = NSLocalizedString("LibraryPresenter.empty", comment:String())
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        viewModels.update(viewModel:viewModel)
    }
    
    private func showItems() {
        var viewModel = LibraryItems()
        viewModel.items = self.items
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        viewModels.update(viewModel:viewModel)
    }
    
    private var items:[LibraryItem] {
        var items:[LibraryItem] = []
        interactor.library.boards.forEach { (key, board) in
            var item = LibraryItem()
            item.board = key
            item.name = board.text
            item.progress = interactor.makeStats(board:board).progress
            items.append(item)
        }
        return items.sorted { (left, right) -> Bool in
            return left.name.caseInsensitiveCompare(right.name) == .orderedAscending
        }
    }
    
    private func registerShortcuts() {
        var items:[UIApplicationShortcutItem] = []
        let icon = UIApplicationShortcutIcon(templateImageName:"assetQuickIcon")
        let boards = interactor.library.boards.sorted { (left, right) -> Bool in
            return left.value.text.caseInsensitiveCompare(right.value.text) == .orderedAscending
        }
        boards.forEach { element in
            items.append(UIApplicationShortcutItem(type:String(), localizedTitle:element.value.text, localizedSubtitle:
                nil, icon:icon, userInfo:["board":NSString(string:element.key)]))
        }
        DispatchQueue.main.async { UIApplication.shared.shortcutItems = items }
    }
}
