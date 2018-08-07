import Foundation
import Domain

class TextCreateColumn:TextStrategy {
    var text:String
    var title:String
    
    init() {
        self.text = String()
        self.title = NSLocalizedString("TextCreateColumn.title", comment:String())
    }
    
    func success(interactor:BoardInteractor, text:String) {
        let column:Column = Factory.makeColumn()
        column.text = text
        interactor.board.columns.append(column)
        interactor.save()
    }
}
