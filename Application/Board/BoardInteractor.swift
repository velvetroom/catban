import Foundation
import CleanArchitecture
import Catban

class BoardInteractor:Interactor {    
    weak var delegate:InteractorDelegate?
    var board:Board!
    var identifier = String()
    var cardsFont:Int { return library.cardsFont }
    var boardName:String { return board.text }
    var boardUrl:String { return library.url(identifier:identifier) }
    private let library = Factory.makeLibrary()
    private let report = Report()
    
    required init() { }
    
    func detach(card:Card, column:Column) {
        column.delete(card:card)
    }
    
    func attach(card:Card, column:Column, after:Card?) {
        if let after:Card = after {
            column.insert(card:card, after:after)
        } else {
            column.makeFirst(card:card)
        }
        save()
    }
    
    func share() {
        let view = ShareView(presenter:SharePresenter())
        view.presenter.interactor = self
        Application.router.present(view, animated:true)
    }
    
    func info() {
        let view = InfoView(presenter:InfoPresenter<BoardInteractor>())
        view.presenter.interactor = self
        view.presenter.source = "InfoBoard"
        Application.router.present(view, animated:true)
    }
    
    func edit() {
        var text = EditText()
        text.title = NSLocalizedString("BoardInteractor.boardTitle", comment:String())
        text.subject = board
        text.save = EditPresenter.saveTextChange
        var delete = EditDelete()
        delete.title = NSLocalizedString("BoardInteractor.deleteBoard", comment:String())
        delete.confirm = DeletePresenter.confirmBoard
        edit(text:text, delete:delete)
    }
    
    func newColumn() {
        var text = EditText()
        text.title = NSLocalizedString("BoardInteractor.newColumn", comment:String())
        text.save = EditPresenter.saveNewColumn
        edit(text:text)
    }
    
    func editColumn(column:Column) {
        var text = EditText()
        text.title = NSLocalizedString("BoardInteractor.columnTitle", comment:String())
        text.subject = column
        text.save = EditPresenter.saveTextChange
        var delete = EditDelete()
        delete.title = NSLocalizedString("BoardInteractor.deleteColumn", comment:String())
        delete.column = column
        delete.confirm = DeletePresenter.confirmColumn
        edit(text:text, delete:delete)
    }
    
    func newCard(column:Column) {
        var text = EditText()
        text.title = NSLocalizedString("BoardInteractor.newCard", comment:String())
        text.other = column
        text.save = EditPresenter.saveNewCard
        edit(text:text, infoSource:"InfoCard")
    }
    
    func editCard(column:Column, card:Card) {
        var text = EditText()
        text.title = column.text
        text.subject = card
        text.save = EditPresenter.saveTextChange
        var delete = EditDelete()
        delete.title = NSLocalizedString("BoardInteractor.deleteCard", comment:String())
        delete.column = column
        delete.card = card
        delete.confirm = DeletePresenter.confirmCard
        edit(text:text, delete:delete, infoSource:"InfoCard")
    }
    
    func save() {
        library.save(board:board)
    }
    
    func makeStats() -> ReportStats {
        return report.makeStats(board:board)
    }
    
    private func edit(text:EditText, delete:EditDelete? = nil, infoSource:String? = nil) {
        let view = EditView(presenter:EditPresenter())
        view.presenter.editText = text
        view.presenter.editDelete = delete
        view.presenter.interactor = self
        view.presenter.infoSource = infoSource
        Application.router.pushViewController(view, animated:true)
    }
}
