import Foundation
import Catban

class TextCreateCard:TextStrategy {
    var text = String()
    var title = NSLocalizedString("TextCreateCard.title", comment:String())
    var column:Column?
    
    func save(interactor:BoardInteractor, text:String) {
        column?.addCard(text:validate(text:text))
        interactor.save()
    }
}
