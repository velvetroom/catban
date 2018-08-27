import Foundation
import CleanArchitecture

struct LibraryItem:ViewModel {
    var board:String
    var name:String
    var progress:Float
    
    init() {
        board = String()
        name = String()
        progress = 0
    }
}
