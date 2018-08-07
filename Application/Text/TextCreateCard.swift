import Foundation
import Domain

class TextCreateCard:TextStrategy {
    var text:String
    var title:String
    var column:Column?
    
    init() {
        self.text = String()
        self.title = NSLocalizedString("TextCreateCard.title", comment:String())
    }
    
    func success(interactor:BoardInteractor, text:String) {
        let card:Card = Factory.makeCard()
        self.update(subject:card, text:text)
        self.column?.cards.append(card)
        interactor.save()
    }
}
