import UIKit
import CleanArchitecture

class NamePresenter:Presenter {
    var interactor:NameInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    func update(name:String) {
        self.interactor.update(name:name)
        DispatchQueue.main.async { Application.router.popViewController(animated:true) }
    }
    
    @objc func cancel() {
        Application.router.popViewController(animated:true)
    }
}
