import UIKit
import CleanArchitecture

class EditPresenter:Presenter {
    weak var interactor:BoardInteractor!
    var viewModels:ViewModels!
    var strategyText:TextStrategy!
    var strategyDelete:DeleteStrategy?
    
    required init() { }
    
    func save(text:String) {
        self.strategyText.save(interactor:self.interactor, text:text)
        DispatchQueue.main.async { Application.router.popViewController(animated:true) }
    }
    
    @objc func cancel() {
        Application.router.popViewController(animated:true)
    }
    
    @objc func delete() {
        let view:DeleteView = DeleteView(presenter:DeletePresenter())
        view.presenter.interactor = self.interactor
        view.presenter.strategy = self.strategyDelete
        Application.router.present(view, animated:true, completion:nil)
    }
    
    @objc func info() {
        let view:InfoView = InfoView(presenter:InfoPresenter<BoardInteractor>())
        view.presenter.interactor = self.interactor
        Application.router.present(view, animated:true, completion:nil)
    }
}
