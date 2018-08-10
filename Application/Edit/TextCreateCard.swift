import Foundation
import Catban

class TextCreateCard:TextStrategy {
    var text:String
    var title:String
    var column:Column?
    
    init() {
        self.text = String()
        self.title = NSLocalizedString("TextCreateCard.title", comment:String())
    }
    
    func save(interactor:BoardInteractor, text:String) {
        let card:Card = Factory.makeCard()
        self.column?.cards.append(card)
        self.save(interactor:interactor, subject:card, text:text)
    }
}
