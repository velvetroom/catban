import Foundation
import CleanArchitecture

struct BoardProgressViewModel:ViewModel {
    var progress:Float
    
    init() {
        self.progress = 0.0
    }
}
