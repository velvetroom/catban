import Foundation
import CleanArchitecture

class BoardPresenter:Presenter {
    var interactor:BoardInteractor!
    var viewModels:ViewModels!
    private let factory:BoardFactory
    
    required init() {
        self.factory = BoardFactory()
    }
    
    @objc func delete() {
        self.interactor.delete()
    }
    
    @objc func name() {
        self.interactor.name()
    }
    
    @objc func share() {
        
    }
    
    func didLoad() {
        self.factory.board = self.interactor.board
    }
    
    func didAppear() {
        self.updateViewModel()
    }
    
    private func updateViewModel() {
        var viewModel:BoardViewModel = BoardViewModel()
        viewModel.title = self.interactor.board.name
        self.viewModels.update(viewModel:viewModel)
    }
}
