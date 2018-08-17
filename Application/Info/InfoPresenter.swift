import Foundation
import CleanArchitecture

class InfoPresenter<I:InfoInteractor>:Presenter {
    var interactor:I!
    var viewModels:ViewModels!
    
    required init() { }
}
