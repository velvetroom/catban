import Foundation
import CleanArchitecture
import Domain

class BoardInteractor:Interactor {
    var board:BoardProtocol!
    weak var delegate:InteractorDelegate?
    
    required init() { }
    
    func name() {
        let view:NameView = NameView()
        view.presenter.interactor.board = self.board
        view.presenter.interactor.model = self.board
        Application.router.pushViewController(view, animated:true)
    }
    
    func delete() {
        let view:DeleteView = DeleteView()
        view.presenter.interactor.board = self.board
        Application.router.present(view, animated:true, completion:nil)
    }
}
