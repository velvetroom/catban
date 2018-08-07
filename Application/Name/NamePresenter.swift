import UIKit
import CleanArchitecture

class NamePresenter:Presenter {
    var interactor:BoardInteractor!
    var viewModels:ViewModels!
    var strategy:NameStrategy!
    
    required init() { }
    
    func update(name:String) {
        self.strategy.success(interactor:self.interactor, name:name)
        DispatchQueue.main.async { Application.router.popViewController(animated:true) }
    }
    
    @objc func cancel() {
        Application.router.popViewController(animated:true)
    }
}
