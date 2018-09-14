import UIKit
import CleanArchitecture
import Catban

class EditPresenter:Presenter<BoardInteractor> {
    var editText:EditText!
    var editDelete:EditDelete?
    var infoSource:String?
    var column:Column!
    
    func save(text:String) {
        editText.save(self)(validate(text:text))
        interactor.save()
        DispatchQueue.main.async { Application.router.popViewController(animated:true) }
    }
    
    func saveBoardRename(text:String) {
        editText.board.name = text
    }
    
    func saveColumnRename(text:String) {
        editText.column.name = text
    }
    
    func saveCardChange(text:String) {
        editText.card.content = text
    }
    
    func saveNewColumn(text:String) {
        interactor.board.addColumn(text:text)
    }
    
    func saveNewCard(text:String) {
        editText.column.addCard(text:text)
    }
    
    @objc func cancel() {
        Application.router.popViewController(animated:true)
    }
    
    @objc func delete() {
        let view = DeleteView(presenter:DeletePresenter())
        view.presenter.interactor = interactor
        view.presenter.edit = editDelete
        Application.router.present(view, animated:true)
    }
    
    @objc func info() {
        let view = InfoView(presenter:InfoPresenter())
        view.presenter.interactor = interactor
        view.presenter.source = infoSource!
        Application.router.present(view, animated:true)
    }
    
    private func validate(text:String) -> String {
        var text = text
        if text.isEmpty || text == " " {
            text = "-"
        }
        return text
    }
}
