import Foundation
import CleanArchitecture
import Domain

class NameInteractor:Interactor {
    weak var board:BoardProtocol!
    var model:NameProtocol!
    weak var delegate:InteractorDelegate?
    private let library:LibraryProtocol
    
    required init() {
        self.library = Factory.makeLibrary()
    }
    
    func update(name:String) {
        self.model.name = name
        do { try self.library.save(board:self.board) } catch { }
    }
}
