import Foundation
import CleanArchitecture

struct LibraryViewModel:ViewModel {
    var items:[LibraryItemViewModel]
    var message:String
    var loadingHidden:Bool
    var actionsEnabled:Bool
    
    init() {
        items = []
        message = String()
        loadingHidden = false
        actionsEnabled = false
    }
}
