import Foundation
import CleanArchitecture

class SettingsPresenter:Presenter {
    var interactor:SettingsInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    func update(cardsFont:Int) {
        interactor.library.cardsFont = cardsFont
    }
    
    func update(defaultColumns:Bool) {
        interactor.library.defaultColumns = defaultColumns
    }
    
    func didLoad() {
        var viewModel = SettingsViewModel()
        viewModel.cardsFont = interactor.library.cardsFont
        viewModel.defaultColumns = interactor.library.defaultColumns
        viewModels.update(viewModel:viewModel)
    }
}
