import Foundation
import Domain

class BoardFactory {
    weak var board:BoardProtocol!
    var items:[BoardItemViewModel]
    
    init() {
        self.items = []
    }
    
    func make() {
        self.items = []
        self.board.columns.forEach { (column:Column) in
            
        }
    }
}
