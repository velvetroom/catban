import Foundation
import Domain

class TextChange:TextStrategy {
    var text:String
    var title:String
    var subject:TextProtocol!
    
    init() {
        self.text = String()
        self.title = String()
    }
    
    func success(interactor:BoardInteractor, text:String) {
        self.subject.text = text
        interactor.save()
    }
}
