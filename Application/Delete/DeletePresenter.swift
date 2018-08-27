import Foundation
import CleanArchitecture

class DeletePresenter:Presenter {
    weak var interactor:BoardInteractor!
    var viewModels:ViewModels!
    var strategy:DeleteStrategy!
    
    required init() { }
    
    @objc func cancel() {
        Application.router.dismiss(animated:true)
    }
    
    @objc func delete() {
        strategy.delete(interactor:interactor)
        Application.router.dismiss(animated:true) {
            Application.router.popViewController(animated:true)
        }
    }
}
