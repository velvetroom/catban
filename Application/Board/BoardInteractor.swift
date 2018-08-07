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
    
    func edit() {
        let text:TextChange = TextChange()
        text.title = NSLocalizedString("BoardInteractor.boardTitle", comment:String())
        text.text = self.board.text
        text.subject = self.board
        self.edit(text:text, delete:DeleteBoard())
    }
    
    func newColumn() {
        self.edit(text:TextCreateColumn(), delete:nil)
    }
    
    func editColumn(column:Column) {
        let text:TextChange = TextChange()
        text.title = NSLocalizedString("BoardInteractor.columnTitle", comment:String())
        text.text = column.text
        text.subject = column
        let delete:DeleteColumn = DeleteColumn()
        delete.column = column
        self.edit(text:text, delete:delete)
    }
    
    func newCard(column:Column) {
        let text:TextCreateCard = TextCreateCard()
        text.column = column
        self.edit(text:text, delete:nil)
    }
    
    func editCard(column:Column, card:Card) {
        let text:TextChange = TextChange()
        text.title = column.text
        text.text = card.text
        text.subject = card
        let delete:DeleteCard = DeleteCard()
        delete.column = column
        delete.card = card
        self.edit(text:text, delete:delete)
    }
    
    func save() {
        do { try self.library.save(board:self.board) } catch { }
    }
    
    private func edit(text:TextStrategy, delete:DeleteStrategy?) {
        let presenter:EditPresenter = EditPresenter()
        let view:EditView = EditView(presenter:presenter)
        presenter.strategyText = text
        presenter.strategyDelete = delete
        presenter.interactor = self
        Application.router.pushViewController(view, animated:true)
    }
}
