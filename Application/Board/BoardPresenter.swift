import CleanArchitecture
import Catban

class BoardPresenter:Presenter {
    var board:Board!
    var identifier = String()
    var cardsFont:Int { return library.cardsFont }
    var boardName:String { return board.name }
    var boardUrl:String { return library.url(identifier:identifier) }
    private(set) var state:BoardState = BoardStateDefault()
    private let library = Factory.makeLibrary()
    private let report = Report()
    
    func search(text:String) {
        state = BoardStateSearch(text:text)
        update(viewModel:board.name)
    }
    
    func clearSearch() {
        state = BoardStateDefault()
        update(viewModel:board.name)
    }
    
    func detach(item:BoardCardView) {
        item.column.delete(card:item.card)
        item.column = nil
    }
    
    func attach(item:BoardCardView, after:BoardItemView) {
        if let card = after.card {
            after.column.insert(card:item.card, after:card)
        } else {
            after.column.makeFirst(card:item.card)
        }
        library.save(board:board)
        item.column = after.column
    }
    
    func delete() {
        Application.navigation.dismiss(animated:false)
        let view = DeleteView(presenter:DeletePresenter())
        view.presenter.board = board
        view.presenter.edit = makeDeleteBoard()
        Application.navigation.present(view, animated:true)
    }
    
    func updateProgress() {
        let stats = report.makeStats(board:board)
        update(viewModel:stats.progress)
        update(viewModel:stack(stats:stats))
    }
    
    @objc func edit() {
        Application.navigation.dismiss(animated:false)
        var text = EditText()
        text.title = .local("BoardPresenter.boardTitle")
        text.text = board.name
        text.board = board
        text.save = EditPresenter.saveBoardRename
        edit(text:text, delete:makeDeleteBoard())
    }
    
    @objc func info() {
        Application.navigation.dismiss(animated:false)
        let view = InfoView(presenter:InfoPresenter())
        view.presenter.source = "InfoBoard"
        Application.navigation.present(view, animated:true)
    }
    
    @objc func share() {
        Application.navigation.dismiss(animated:false)
        let view = ShareView(presenter:SharePresenter())
        view.presenter.boardUrl = boardUrl
        view.presenter.board = board
        Application.navigation.present(view, animated:true)
    }
    
    @objc func newColumn() {
        Application.navigation.dismiss(animated:false)
        var text = EditText()
        text.title = .local("BoardPresenter.newColumn")
        text.save = EditPresenter.saveNewColumn
        edit(text:text)
    }
    
    @objc func editColumn(view:BoardItemView) {
        Application.navigation.dismiss(animated:false)
        var text = EditText()
        text.title = .local("BoardPresenter.columnTitle")
        text.text = view.column.name
        text.column = view.column
        text.save = EditPresenter.saveColumnRename
        var delete = EditDelete()
        delete.title = .local("BoardPresenter.deleteColumn")
        delete.column = view.column
        delete.confirm = DeletePresenter.confirmColumn
        edit(text:text, delete:delete)
    }
    
    @objc func newCard(view:BoardItemView) {
        Application.navigation.dismiss(animated:false)
        var text = EditText()
        text.title = .local("BoardPresenter.newCard")
        text.column = view.column
        text.save = EditPresenter.saveNewCard
        edit(text:text, infoSource:"InfoCard")
    }
    
    @objc func editCard(view:BoardCardView) {
        Application.navigation.dismiss(animated:false)
        var text = EditText()
        text.title = view.column.name
        text.text = view.card.content
        text.card = view.card
        text.save = EditPresenter.saveCardChange
        var delete = EditDelete()
        delete.title = .local("BoardPresenter.deleteCard")
        delete.column = view.column
        delete.card = view.card
        delete.confirm = DeletePresenter.confirmCard
        edit(text:text, delete:delete, infoSource:"InfoCard")
    }
    
    override func didAppear() {
        update(viewModel:board.name)
        DispatchQueue.global(qos:.background).async { [weak self] in self?.updateProgress() }
    }
    
    private func edit(text:EditText, delete:EditDelete? = nil, infoSource:String? = nil) {
        let view = EditView(presenter:EditPresenter())
        view.presenter.editText = text
        view.presenter.editDelete = delete
        view.presenter.board = board
        view.presenter.infoSource = infoSource
        Application.navigation.pushViewController(view, animated:true)
    }
    
    private func makeDeleteBoard() -> EditDelete {
        var delete = EditDelete()
        delete.title = String(format:.local("BoardPresenter.deleteBoard"), board.name)
        delete.confirm = DeletePresenter.confirmBoard
        return delete
    }
    
    private func stack(stats:ReportStats) -> [(CGFloat, CGFloat)] {
        var previous = (-CGFloat.pi / 2) + 0.075
        let max = (CGFloat.pi * 2) + (previous - 0.15)
        return stats.columns.reversed().reduce(into:[(CGFloat, CGFloat)]()) { progress, stat in
            let percent = CGFloat(stat) / CGFloat(stats.cards)
            if percent == 1 {
                progress.append((0.0001, 0))
            } else if percent == 0 {
                progress.append((previous, previous))
            } else {
                var next = previous + (percent * (CGFloat.pi * 2))
                next = min(next, max)
                progress.append((previous, next))
                previous = next + 0.15
                previous = min(previous, max)
            }
        }
    }
}
