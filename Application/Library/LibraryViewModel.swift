import Foundation
import CleanArchitecture

struct LibraryViewModel:ViewModel {
    var items:[LibraryItemViewModel]
    var message:String
    var loadingHidden:Bool
    
    init() {
        self.items = []
        self.message = String()
        self.loadingHidden = true
    }
}
