import Foundation
import Catban

class TextChange:TextStrategy {
    var text = String()
    var title = String()
    var subject:TextProtocol!
    
    func save(interactor:BoardInteractor, text:String) {
        subject.text = validate(text:text)
        interactor.save()
    }
}
