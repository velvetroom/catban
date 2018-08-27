import Foundation
import CleanArchitecture
import Catban

class SettingsInteractor:Interactor {
    weak var delegate:InteractorDelegate?
    let library = Factory.makeLibrary()
    
    required init() { }
}
