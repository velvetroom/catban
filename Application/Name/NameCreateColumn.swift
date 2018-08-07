import Foundation
import Domain

class NameCreateColumn:NameStrategy {
    var subject:NameProtocol!
    let title:String
    
    init() {
        self.title = NSLocalizedString("NameCreateColumn.title", comment:String())
    }
    
    func success(interactor:BoardInteractor, name:String) {
        guard let column:Column = self.subject as? Column else { return }
        column.name = name
        interactor.board.columns.append(column)
        interactor.save()
    }
}
