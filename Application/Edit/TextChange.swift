import Foundation
import Catban

class TextChange:TextStrategy {
    var text:String
    var title:String
    var subject:TextProtocol!
    
    init() {
        self.text = String()
        self.title = String()
    }
    
    func save(interactor:BoardInteractor, text:String) {
        self.subject.text = self.validate(text:text)
        interactor.save()
    }
}
