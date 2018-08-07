import Foundation
import Domain

protocol NameStrategy {
    var subject:NameProtocol! { get set }
    var title:String { get }
    
    func success(interactor:BoardInteractor, name:String)
}
