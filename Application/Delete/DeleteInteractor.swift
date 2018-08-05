import Foundation
import CleanArchitecture
import Domain

class DeleteInteractor:Interactor {
    weak var board:BoardProtocol!
    weak var delegate:InteractorDelegate?
    
    required init() { }
    
    func cancel() {
        Application.router.dismiss(animated:true, completion:nil)
    }
    
    func delete() {
        Application.router.dismiss(animated:true) {
            Application.router.popViewController(animated:true)
        }
    }
}
