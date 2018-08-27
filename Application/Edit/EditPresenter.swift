import UIKit
import CleanArchitecture
import Catban

class EditPresenter:Presenter {
    weak var interactor:BoardInteractor!
    var viewModels:ViewModels!
    var strategyDelete:DeleteStrategy?
    var infoSource:String?
    var editText:EditText!
    
    required init() { }
    
    func save(text:String) {
        editText.save(self)(validate(text:text))
        interactor.save()
        DispatchQueue.main.async { Application.router.popViewController(animated:true) }
    }
    
    func saveTextChange(text:String) {
        editText.subject!.text = text
    }
    
    func saveNewColumn(text:String) {
        interactor.board.addColumn(text:text)
    }
    
    func saveNewCard(text:String) {
        (editText.other as! Column).addCard(text:text)
    }
    
    @objc func cancel() {
        Application.router.popViewController(animated:true)
    }
    
    @objc func delete() {
        let view = DeleteView(presenter:DeletePresenter())
        view.presenter.interactor = interactor
        view.presenter.strategy = strategyDelete
        Application.router.present(view, animated:true)
    }
    
    @objc func info() {
        let view = InfoView(presenter:InfoPresenter<BoardInteractor>())
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
