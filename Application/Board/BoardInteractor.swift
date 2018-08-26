import Foundation
import CleanArchitecture
import Catban

class BoardInteractor:Interactor, InfoInteractor {    
    weak var delegate:InteractorDelegate?
    var board:Board!
    var identifier:String
    var cardsFont:Int { return library.cardsFont }
    var boardName:String { return board.text }
    var boardUrl:String { return library.url(identifier:identifier) }
    private let library:Library
    private let report:Report
    
    required init() {
        library = Factory.makeLibrary()
        report = Report()
        identifier = String()
    }
    
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
    
    func edit() {
        let text = TextChange()
        text.title = NSLocalizedString("BoardInteractor.boardTitle", comment:String())
        text.text = board.text
        text.subject = board
        edit(text:text, delete:DeleteBoard(), infoSource:nil)
    }
    
    func info() {
        let view = InfoView(presenter:InfoPresenter<BoardInteractor>())
        view.presenter.interactor = self
        view.presenter.source = "InfoBoard"
        Application.router.present(view, animated:true)
    }
    
    func newColumn() {
        edit(text:TextCreateColumn(), delete:nil, infoSource:nil)
    }
    
    func editColumn(column:Column) {
        let text = TextChange()
        text.title = NSLocalizedString("BoardInteractor.columnTitle", comment:String())
        text.text = column.text
        text.subject = column
        let delete = DeleteColumn()
        delete.column = column
        edit(text:text, delete:delete, infoSource:nil)
    }
    
    func newCard(column:Column) {
        let text = TextCreateCard()
        text.column = column
        edit(text:text, delete:nil, infoSource:"InfoCard")
    }
    
    func editCard(column:Column, card:Card) {
        let text = TextChange()
        text.title = column.text
        text.text = card.text
        text.subject = card
        let delete = DeleteCard()
        delete.column = column
        delete.card = card
        edit(text:text, delete:delete, infoSource:"InfoCard")
    }
    
    func save() {
        library.save(board:board)
    }
    
    func makeStats() -> ReportStats {
        return report.makeStats(board:board)
    }
    
    private func edit(text:TextStrategy, delete:DeleteStrategy?, infoSource:String?) {
        let view = EditView(presenter:EditPresenter())
        view.presenter.strategyText = text
        view.presenter.strategyDelete = delete
        view.presenter.interactor = self
        view.presenter.infoSource = infoSource
        Application.router.pushViewController(view, animated:true)
    }
}
