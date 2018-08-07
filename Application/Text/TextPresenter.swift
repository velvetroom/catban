import UIKit
import CleanArchitecture

class TextPresenter:Presenter {
    var interactor:BoardInteractor!
    var viewModels:ViewModels!
    var strategy:TextStrategy!
    
    required init() { }
    
    func update(text:String) {
        self.strategy.success(interactor:self.interactor, text:text)
        DispatchQueue.main.async { Application.router.popViewController(animated:true) }
    }
    
    @objc func cancel() {
        Application.router.popViewController(animated:true)
    }
}
