import Foundation
import CleanArchitecture

struct DeleteViewModel:ViewModel {
    var message:NSMutableAttributedString
    
    init() {
        self.message = NSMutableAttributedString()
    }
}
