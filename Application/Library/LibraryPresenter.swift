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
            UIApplication.shared.shortcutItems = []
        } else {
            DispatchQueue.global(qos:.background).async { [weak self] in self?.updateItems() }
        }
    }
    
    private func showEmpty() {
        var viewModel = LibraryItems()
        viewModel.message = NSLocalizedString("LibraryPresenter.empty", comment:String())
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        viewModels.update(viewModel:viewModel)
    }
    
    private func updateItems() {
        let items = self.items
        showItems(items:items)
        registerShortcuts(items:items)
        Today(items:items).store()
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
    
    private func showItems(items:[LibraryItem]) {
        var viewModel = LibraryItems()
        viewModel.items = items
        viewModel.loadingHidden = true
        viewModel.actionsEnabled = true
        viewModels.update(viewModel:viewModel)
    }
    
    private func registerShortcuts(items:[LibraryItem]) {
        var shortcuts:[UIApplicationShortcutItem] = []
        let icon = UIApplicationShortcutIcon(templateImageName:"assetQuickIcon")
        items.forEach { item in
            shortcuts.append(UIApplicationShortcutItem(type:String(), localizedTitle:item.name, localizedSubtitle:
                nil, icon:icon, userInfo:["board":NSString(string:item.board)]))
        }
        DispatchQueue.main.async { UIApplication.shared.shortcutItems = shortcuts }
    }
}
