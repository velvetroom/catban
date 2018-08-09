import Foundation
import CleanArchitecture

class BoardPresenter:Presenter {
    var interactor:BoardInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    func detach(item:BoardItemView) {
        self.interactor.detach(card:item.card, column:item.column)
        item.column = nil
    }
    
    func attach(item:BoardItemView, after:BoardItemView) {
        self.interactor.attach(card:item.card, column:after.column, after:after.card)
        item.column = after.column
    }
    
    @objc func edit() {
        self.interactor.edit()
    }
    
    @objc func share() {
        self.interactor.share()
    }
    
    @objc func newColumn() {
        self.interactor.newColumn()
    }
    
    @objc func editColumn(view:BoardItemView) {
        self.interactor.editColumn(column:view.column!)
    }
    
    @objc func newCard(view:BoardItemView) {
        self.interactor.newCard(column:view.column!)
    }
    
    @objc func editCard(view:BoardItemView) {
        self.interactor.editCard(column:view.column!, card:view.card!)
    }
    
    func didAppear() {
        self.updateViewModel()
    }
    
    private func updateViewModel() {
        var viewModel:BoardViewModel = BoardViewModel()
        viewModel.title = self.interactor.board.text
        self.viewModels.update(viewModel:viewModel)
    }
}
