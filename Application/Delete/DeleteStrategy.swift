import Foundation
import Catban

protocol DeleteStrategy {
    var title:String { get }
    
    func delete(interactor:BoardInteractor)
}
