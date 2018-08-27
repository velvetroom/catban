import Foundation
import CleanArchitecture

struct BoardProgress:ViewModel {
    var progress:Float
    var columns:[Int]
    
    init() {
        progress = 0
        columns = []
    }
}
