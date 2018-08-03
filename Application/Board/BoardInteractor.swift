import Foundation
import CleanArchitecture
import Domain

class BoardInteractor:Interactor {
    weak var board:BoardProtocol!
    weak var delegate:InteractorDelegate?
    
    required init() { }
}
