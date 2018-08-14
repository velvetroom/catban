import Foundation
import Catban

class TextCreateColumn:TextStrategy {
    var text:String
    var title:String
    
    init() {
        self.text = String()
        self.title = NSLocalizedString("TextCreateColumn.title", comment:String())
    }
    
    func save(interactor:BoardInteractor, text:String) {
        interactor.board.addColumn(text:self.validate(text:text))
        interactor.save()
    }
}
