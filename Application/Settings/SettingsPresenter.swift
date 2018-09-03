import Foundation
import CleanArchitecture

class SettingsPresenter:Presenter<SettingsInteractor> {    
    func update(cardsFont:Int) {
        interactor.library.cardsFont = cardsFont
    }
    
    func update(defaultColumns:Bool) {
        interactor.library.defaultColumns = defaultColumns
    }
    
    override func didLoad() {
        var viewModel = SettingsViewModel()
        viewModel.cardsFont = interactor.library.cardsFont
        viewModel.defaultColumns = interactor.library.defaultColumns
        update(viewModel:viewModel)
    }
}
