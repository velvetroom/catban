import Foundation
import Domain

protocol DeleteStrategy {
    var title:String { get }
    
    func delete(interactor:BoardInteractor)
}
