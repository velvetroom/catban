import Foundation
import CleanArchitecture

struct LibraryViewModel:ViewModel {
    var items:[LibraryItemViewModel]
    var message:String
    var loadingHidden:Bool
    var addEnabled:Bool
    
    init() {
        self.items = []
        self.message = String()
        self.loadingHidden = false
        self.addEnabled = false
    }
}
