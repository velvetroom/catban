import Foundation
import CleanArchitecture

struct BoardProgressViewModel:ViewModel {
    var progress:Float
    var columns:[Int]
    
    init() {
        self.progress = 0.0
        self.columns = []
    }
}
