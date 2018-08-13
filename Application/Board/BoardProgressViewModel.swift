import UIKit
import CleanArchitecture

struct BoardProgressViewModel:ViewModel {
    var progress:CGFloat
    
    init() {
        self.progress = 0.0
    }
}
