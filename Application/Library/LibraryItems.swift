import Foundation
import CleanArchitecture

struct LibraryItems:ViewModel {
    var items:[LibraryItem] = []
    var message = String()
    var loadingHidden = false
    var actionsEnabled = false
}
