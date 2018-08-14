import Foundation
import Catban

class DeleteColumn:DeleteStrategy {
    var column:Column!
    let title:String
    
    init() {
        self.title = NSLocalizedString("DeleteColumn.title", comment:String())
    }
    
    func delete(interactor:BoardInteractor) {
        interactor.board.delete(column:self.column)
        interactor.save()
    }
}
