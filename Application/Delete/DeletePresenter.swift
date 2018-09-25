import CleanArchitecture
import Catban

class DeletePresenter:Presenter {
    weak var board:Board!
    var edit:EditDelete!
    private let library = Factory.makeLibrary()
    @objc func cancel() { Application.navigation.dismiss(animated:true) }
    
    @objc func delete() {
        edit.confirm(self)()
        Application.navigation.dismiss(animated:true) {
            Application.navigation.popViewController(animated:true)
        }
    }
    
    func confirmBoard() {
        Factory.makeLibrary().delete(board:board)
        Application.navigation.popViewController(animated:false)
    }
    
    func confirmColumn() {
        board.delete(column:edit.column!)
        library.save(board:board)
    }
    
    func confirmCard() {
        edit.column!.delete(card:edit.card!)
        library.save(board:board)
    }
}
