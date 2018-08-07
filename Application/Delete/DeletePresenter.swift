import Foundation
import CleanArchitecture

class DeletePresenter:Presenter {
    var interactor:BoardInteractor!
    var viewModels:ViewModels!
    var strategy:DeleteStrategy!
    
    required init() { }
    
    @objc func cancel() {
        Application.router.dismiss(animated:true, completion:nil)
    }
    
    @objc func delete() {
        self.strategy.delete(interactor:self.interactor)
        Application.router.dismiss(animated:true) {
            Application.router.popViewController(animated:true)
        }
    }
}
