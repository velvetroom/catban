import Foundation
import Catban

class DeleteColumn:DeleteStrategy {
    var column:Column!
    let title = NSLocalizedString("DeleteColumn.title", comment:String())
    
    func delete(interactor:BoardInteractor) {
        interactor.board.delete(column:column)
        interactor.save()
    }
}
