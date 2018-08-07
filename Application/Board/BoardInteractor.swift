import Foundation
import CleanArchitecture
import Domain

class BoardInteractor:Interactor {
    weak var delegate:InteractorDelegate?
    var board:BoardProtocol!
    private let library:LibraryProtocol
    
    required init() {
        self.library = Factory.makeLibrary()
    }
    
    func name() {
        var strategy:NameStrategy = NameChange()
        strategy.subject = self.board
        self.name(strategy:strategy)
    }
    
    func delete() {
        let view:DeleteView = DeleteView()
        view.presenter.interactor.board = self.board
        Application.router.present(view, animated:true, completion:nil)
    }
    
    func save() {
        do { try self.library.save(board:self.board) } catch { }
    }
    
    private func name(strategy:NameStrategy) {
        let presenter:NamePresenter = NamePresenter()
        let view:NameView = NameView(presenter:presenter)
        presenter.strategy = strategy
        presenter.interactor = self
        Application.router.pushViewController(view, animated:true)
    }
}
