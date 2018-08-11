import Foundation
import Catban

protocol TextStrategy {
    var text:String { get set }
    var title:String { get set }
    
    func save(interactor:BoardInteractor, text:String)
}

extension TextStrategy {
    func validate(text:String) -> String {
        var text:String = text
        if text.isEmpty || text == " " {
            text = "-"
        }
        return text
    }
}
