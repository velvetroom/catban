import Foundation
import CleanArchitecture
import Catban

class BoardInteractor:Interactor, InfoInteractor {    
    weak var delegate:InteractorDelegate?
    var board:Board!
    var identifier:String
    var cardsFont:Int { get { return self.library.cardsFont } }
    private let library:Library
    private let report:Report
    
    required init() {
        self.library = Factory.makeLibrary()
        self.report = Report()
        self.identifier = String()
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
        self.save()
    }
    
    func share() {
        let view:ShareView = ShareView(presenter:SharePresenter())
        view.presenter.interactor = self
        Application.router.present(view, animated:true, completion:nil)
    }
    
    func edit() {
        let text:TextChange = TextChange()
        text.title = NSLocalizedString("BoardInteractor.boardTitle", comment:String())
        text.text = self.board.text
        text.subject = self.board
        self.edit(text:text, delete:DeleteBoard(), infoSource:nil)
    }
    
    func info() {
        let view:InfoView = InfoView(presenter:InfoPresenter<BoardInteractor>())
        view.presenter.interactor = self
        view.presenter.source = Constants.infoBoard
        Application.router.present(view, animated:true, completion:nil)
    }
    
    func newColumn() {
        self.edit(text:TextCreateColumn(), delete:nil, infoSource:nil)
    }
    
    func editColumn(column:Column) {
        let text:TextChange = TextChange()
        text.title = NSLocalizedString("BoardInteractor.columnTitle", comment:String())
        text.text = column.text
        text.subject = column
        let delete:DeleteColumn = DeleteColumn()
        delete.column = column
        self.edit(text:text, delete:delete, infoSource:nil)
    }
    
    func newCard(column:Column) {
        let text:TextCreateCard = TextCreateCard()
        text.column = column
        self.edit(text:text, delete:nil, infoSource:Constants.infoCard)
    }
    
    func editCard(column:Column, card:Card) {
        let text:TextChange = TextChange()
        text.title = column.text
        text.text = card.text
        text.subject = card
        let delete:DeleteCard = DeleteCard()
        delete.column = column
        delete.card = card
        self.edit(text:text, delete:delete, infoSource:Constants.infoCard)
    }
    
    func save() {
        self.library.save(board:self.board)
    }
    
    func makeStats() -> ReportStats {
        return self.report.makeStats(board:self.board)
    }
    
    private func edit(text:TextStrategy, delete:DeleteStrategy?, infoSource:String?) {
        let view:EditView = EditView(presenter:EditPresenter())
        view.presenter.strategyText = text
        view.presenter.strategyDelete = delete
        view.presenter.interactor = self
        view.presenter.infoSource = infoSource
        Application.router.pushViewController(view, animated:true)
    }
}

private struct Constants {
    static let infoCard:String = "InfoCard"
    static let infoBoard:String = "InfoBoard"
}
