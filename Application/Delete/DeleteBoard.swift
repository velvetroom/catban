import Foundation
import Catban

class DeleteBoard:DeleteStrategy {
    let title:String
    
    init() {
        self.title = NSLocalizedString("DeleteBoard.title", comment:String())
    }
    
    func delete(interactor:BoardInteractor) {
        do { try Factory.makeLibrary().delete(board:interactor.board) } catch { }
        Application.router.popViewController(animated:false)
    }
}
