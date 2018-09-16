import Foundation
import CleanArchitecture
import Catban

class DeletePresenter:Presenter<BoardInteractor> {
    var edit:EditDelete!
    
    @objc func cancel() {
        Application.navigation.dismiss(animated:true)
    }
    
    @objc func delete() {
        edit.confirm(self)()
        Application.navigation.dismiss(animated:true) {
            Application.navigation.popViewController(animated:true)
        }
    }
    
    func confirmBoard() {
        Factory.makeLibrary().delete(board:interactor.board)
        Application.navigation.popViewController(animated:false)
    }
    
    func confirmColumn() {
        interactor.board.delete(column:edit.column!)
        interactor.save()
    }
    
    func confirmCard() {
        edit.column!.delete(card:edit.card!)
        interactor.save()
    }
}
