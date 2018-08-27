import Foundation
import Catban

class TextCreateColumn:TextStrategy {
    var text = String()
    var title = NSLocalizedString("TextCreateColumn.title", comment:String())
    
    func save(interactor:BoardInteractor, text:String) {
        interactor.board.addColumn(text:validate(text:text))
        interactor.save()
    }
}
