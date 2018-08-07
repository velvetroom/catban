import UIKit
import CleanArchitecture

class EditPresenter:Presenter {
    var interactor:BoardInteractor!
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
        let presenter:DeletePresenter = DeletePresenter()
        let view:DeleteView = DeleteView(presenter:presenter)
        presenter.interactor = self.interactor
        presenter.strategy = self.strategyDelete
        Application.router.present(view, animated:true, completion:nil)
    }
}
