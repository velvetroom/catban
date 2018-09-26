import CleanArchitecture
import Catban

class SettingsPresenter:Presenter {
    private let library = Factory.makeLibrary()
    func update(cardsFont:Int) { library.cardsFont = cardsFont }
    func update(defaultColumns:Bool) { library.defaultColumns = defaultColumns }
    
    override func didLoad() {
        var viewModel = SettingsViewModel()
        viewModel.cardsFont = library.cardsFont
        viewModel.defaultColumns = library.defaultColumns
        update(viewModel:viewModel)
    }
}
