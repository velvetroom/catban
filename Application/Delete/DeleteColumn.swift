import Foundation
import Domain

class DeleteColumn:DeleteStrategy {
    var column:Column!
    let title:String
    
    init() {
        self.title = NSLocalizedString("DeleteColumn.title", comment:String())
    }
    
    func delete(interactor:BoardInteractor) {
        interactor.board.columns.removeAll { (item:Column) -> Bool in item === self.column }
        interactor.save()
    }
}
