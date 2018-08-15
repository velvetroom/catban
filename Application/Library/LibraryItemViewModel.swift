import Foundation
import CleanArchitecture

struct LibraryItemViewModel:ViewModel {
    var board:String
    var name:String
    var progress:Float
    
    init() {
        self.board = String()
        self.name = String()
        self.progress = 0.0
    }
}
