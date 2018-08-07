import Foundation
import Domain

class NameChange:NameStrategy {
    var subject:NameProtocol!
    
    func success(interactor:BoardInteractor, name:String) {
        self.subject.name = name
        interactor.save()
    }
}
