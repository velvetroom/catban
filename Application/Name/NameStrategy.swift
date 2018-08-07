import Foundation
import Domain

protocol NameStrategy {
    var subject:NameProtocol! { get set }
    
    func success(interactor:BoardInteractor, name:String)
}
