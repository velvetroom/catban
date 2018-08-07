import Foundation
import CleanArchitecture

class BoardPresenter:Presenter {
    var interactor:BoardInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    @objc func delete() {
        self.interactor.delete()
    }
    
    @objc func name() {
        self.interactor.name()
    }
    
    @objc func share() {
        
    }
    
    @objc func newColumn() {
        self.interactor.newColumn()
    }
    
    @objc func newCard(view:BoardItemView) {
        self.interactor.newCard(column:view.column!)
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
