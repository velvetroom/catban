import UIKit
import CleanArchitecture

class EditPresenter:Presenter {
    weak var interactor:BoardInteractor!
    var viewModels:ViewModels!
    var strategyText:TextStrategy!
    var strategyDelete:DeleteStrategy?
    var infoSource:String?
    
    required init() { }
    
    func save(text:String) {
        strategyText.save(interactor:interactor, text:text)
        DispatchQueue.main.async { Application.router.popViewController(animated:true) }
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
}
