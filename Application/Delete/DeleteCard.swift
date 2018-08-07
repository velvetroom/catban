import Foundation
import Domain

class DeleteCard:DeleteStrategy {
    var column:Column!
    var card:Card!
    let title:String
    
    init() {
        self.title = NSLocalizedString("DeleteCard.title", comment:String())
    }
    
    func delete(interactor:BoardInteractor) {
        column.cards.removeAll { (item:Card) -> Bool in item === self.card }
        interactor.save()
    }
}
