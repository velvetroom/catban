import CleanArchitecture
import Catban

class EditPresenter:Presenter {
    weak var board:Board!
    var editText:EditText!
    var editDelete:EditDelete?
    var infoSource:String?
    var column:Column!
    private let library = Factory.makeLibrary()
    func saveBoardRename(text:String) { editText.board.name = text }
    func saveColumnRename(text:String) { editText.column.name = text }
    func saveCardChange(text:String) { editText.card.content = text }
    func saveNewColumn(text:String) { board.addColumn(text:text) }
    func saveNewCard(text:String) { editText.column.addCard(text:text) }
    @objc func cancel() { Application.navigation.popViewController(animated:true) }
    
    func save(text:String) {
        editText.save(self)(validate(text:text))
        library.save(board:board)
        DispatchQueue.main.async { Application.navigation.popViewController(animated:true) }
    }
    
    @objc func delete() {
        let view = DeleteView(presenter:DeletePresenter())
        view.presenter.board = board
        view.presenter.edit = editDelete
        Application.navigation.present(view, animated:true)
    }
    
    @objc func info() {
        let view = InfoView(presenter:InfoPresenter())
        view.presenter.source = infoSource!
        Application.navigation.present(view, animated:true)
    }
    
    private func validate(text:String) -> String {
        var text = text
        if text.isEmpty || text == " " {
            text = "-"
        }
        return text
    }
}
