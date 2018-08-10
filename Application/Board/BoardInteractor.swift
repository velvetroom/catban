import Foundation
import CleanArchitecture
import Domain

class BoardInteractor:Interactor {
    weak var delegate:InteractorDelegate?
    var board:Board!
    var identifier:String
    private let library:LibraryProtocol
    
    required init() {
        self.library = Factory.makeLibrary()
        self.identifier = String()
    }
    
    func detach(card:Card, column:Column) {
        column.delete(card:card)
    }
    
    func attach(card:Card, column:Column, after:Card?) {
        if let after:Card = after {
            for index:Int in 0 ..< column.cards.count {
                if column.cards[index] === after {
                    column.cards.insert(card, at:index + 1)
                    break
                }
            }
        } else {
            column.cards.insert(card, at:0)
        }
        self.save()
    }
    
    func share() {
        let presenter:SharePresenter = SharePresenter()
        let view:ShareView = ShareView(presenter:presenter)
        presenter.interactor = self
        Application.router.present(view, animated:true, completion:nil)
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
