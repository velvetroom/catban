import Foundation
import Catban

class DeleteBoard:DeleteStrategy {
    let title = NSLocalizedString("DeleteBoard.title", comment:String())
    
    func delete(interactor:BoardInteractor) {
        Factory.makeLibrary().delete(board:interactor.board)
        Application.router.popViewController(animated:false)
    }
}
