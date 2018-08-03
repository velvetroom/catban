import Foundation
import CleanArchitecture

struct LibraryItemViewModel:ViewModel {
    var board:String
    var name:String
    
    init() {
        self.board = String()
        self.name = String()
    }
}
