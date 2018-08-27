import Foundation
import CleanArchitecture

struct InfoViewModel:ViewModel {
    var text:NSAttributedString
    
    init() {
        text = NSAttributedString()
    }
}
