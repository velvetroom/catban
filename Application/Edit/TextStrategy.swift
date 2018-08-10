import Foundation
import Catban

protocol TextStrategy {
    var text:String { get set }
    var title:String { get set }
    
    func save(interactor:BoardInteractor, text:String)
}

extension TextStrategy {
    func save(interactor:BoardInteractor, subject:TextProtocol, text:String) {
        var subject:TextProtocol = subject
        if text.isEmpty {
            subject.text = "-"
        } else {
            subject.text = text
        }
        interactor.save()
    }
}
