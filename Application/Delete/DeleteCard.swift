import Foundation
import Catban

class DeleteCard:DeleteStrategy {
    var column:Column!
    var card:Card!
    let title = NSLocalizedString("DeleteCard.title", comment:String())
    
    func delete(interactor:BoardInteractor) {
        column.delete(card:card)
        interactor.save()
    }
}
