import Foundation
import CleanArchitecture

struct InfoViewModel:ViewModel {
    var text:NSAttributedString
    
    init() {
        self.text = NSAttributedString()
    }
}
