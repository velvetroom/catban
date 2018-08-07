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
        let strategy:TextChange = TextChange()
        strategy.title = NSLocalizedString("BoardInteractor.boardTitle", comment:String())
        strategy.text = self.board.text
        strategy.subject = self.board
        self.text(strategy:strategy)
    }
    
    func delete() {
        let view:DeleteView = DeleteView()
        view.presenter.interactor.board = self.board
        Application.router.present(view, animated:true, completion:nil)
    }
    
    func newColumn() {
        self.text(strategy:TextCreateColumn())
    }
    
    func editColumn(column:Column) {
        let strategy:TextChange = TextChange()
        strategy.title = NSLocalizedString("BoardInteractor.columnTitle", comment:String())
        strategy.text = column.text
        strategy.subject = column
        self.text(strategy:strategy)
    }
    
    func newCard(column:Column) {
        let strategy:TextCreateCard = TextCreateCard()
        strategy.column = column
        self.text(strategy:strategy)
    }
    
    func editCard(column:Column, card:Card) {
        let strategy:TextChange = TextChange()
        strategy.title = column.text
        strategy.text = card.text
        strategy.subject = card
        self.text(strategy:strategy)
    }
    
    func save() {
        do { try self.library.save(board:self.board) } catch { }
    }
    
    private func text(strategy:TextStrategy) {
        let presenter:TextPresenter = TextPresenter()
        let view:TextView = TextView(presenter:presenter)
        presenter.strategy = strategy
        presenter.interactor = self
        Application.router.pushViewController(view, animated:true)
    }
}
