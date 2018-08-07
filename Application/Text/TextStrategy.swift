import Foundation
import Domain

protocol TextStrategy {
    var text:String { get set }
    var title:String { get set }
    
    func success(interactor:BoardInteractor, text:String)
}
