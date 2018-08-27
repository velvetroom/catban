import Foundation
import CleanArchitecture

struct LibraryItems:ViewModel {
    var items:[LibraryItem]
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
