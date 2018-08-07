import Foundation
import Domain

class NameChange:NameStrategy {
    var subject:NameProtocol!
    let title:String
    
    init() {
        self.title = NSLocalizedString("NameChange.title", comment:String())
    }
    
    func success(interactor:BoardInteractor, name:String) {
        self.subject.name = name
        interactor.save()
    }
}
