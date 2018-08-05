import Foundation
import CleanArchitecture
import Domain

class DeleteInteractor:Interactor {
    var board:BoardProtocol!
    weak var delegate:InteractorDelegate?
    private let library:LibraryProtocol
    
    required init() {
        self.library = Factory.makeLibrary()
    }
    
    func cancel() {
        Application.router.dismiss(animated:true, completion:nil)
    }
    
    func delete() {
        do { try self.library.delete(board:self.board) } catch { }
        Application.router.dismiss(animated:true) {
            Application.router.popViewController(animated:true)
        }
    }
}
