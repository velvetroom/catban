import Foundation
import CleanArchitecture
import Catban

class SettingsInteractor:Interactor {
    weak var delegate:InteractorDelegate?
    let library:Library
    
    required init() {
        library = Factory.makeLibrary()
    }
}
