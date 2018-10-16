import CleanArchitecture
import Catban

class SettingsPresenter:Presenter {
    private let library = Factory.makeLibrary()
    func update(cardsFont:Int) { library.cardsFont = cardsFont }
    func update(defaultColumns:Bool) { library.defaultColumns = defaultColumns }
    
    @objc func done() {
        Application.navigation.setViewControllers([LibraryView()], animated:true)
    }
    
    @objc func skinChange(segmented:UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 0: library.skin = .light
        default: library.skin = .dark
        }
        Application.navigation.setViewControllers([SettingsView()], animated:true)
    }
    
    override func didLoad() {
        var viewModel = SettingsViewModel()
        viewModel.cardsFont = library.cardsFont
        viewModel.defaultColumns = library.defaultColumns
        if library.skin == .dark { viewModel.skin = 1 }
        update(viewModel:viewModel)
    }
}
