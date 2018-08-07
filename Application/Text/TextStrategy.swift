import Foundation
import Domain

protocol TextStrategy {
    var text:String { get set }
    var title:String { get set }
    
    func success(interactor:BoardInteractor, text:String)
}

extension TextStrategy {
    func update(subject:TextProtocol, text:String) {
        var subject:TextProtocol = subject
        if text.isEmpty {
            subject.text = "-"
        } else {
            subject.text = text
        }
    }
}
