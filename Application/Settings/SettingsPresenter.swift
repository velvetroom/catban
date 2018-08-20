import Foundation
import CleanArchitecture

class SettingsPresenter:Presenter {
    var interactor:SettingsInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    func update(cardsFont:Int) {
        self.interactor.library.cardsFont = cardsFont
    }
    
    func update(defaultColumns:Bool) {
        self.interactor.library.defaultColumns = defaultColumns
    }
    
    func didLoad() {
        var viewModel:SettingsViewModel = SettingsViewModel()
        viewModel.cardsFont = self.interactor.library.cardsFont
        viewModel.defaultColumns = self.interactor.library.defaultColumns
        self.viewModels.update(viewModel:viewModel)
    }
}
