import Foundation
import Domain

class TextCreateColumn:TextStrategy {
    var text:String
    var title:String
    
    init() {
        self.text = String()
        self.title = NSLocalizedString("TextCreateColumn.title", comment:String())
    }
    
    func save(interactor:BoardInteractor, text:String) {
        let column:Column = Factory.makeColumn()
        interactor.board.columns.append(column)
        self.save(interactor:interactor, subject:column, text:text)
    }
}
