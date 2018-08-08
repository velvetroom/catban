import Foundation
import CleanArchitecture

class ScanPresenter:Presenter {
    weak var interactor:LibraryInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    @objc func cancel() {
        Application.router.dismiss(animated:true, completion:nil)
    }
}
