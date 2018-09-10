import Foundation
import Catban

struct EditDelete {
    var title = String()
    var column:Column?
    var card:Card?
    var confirm:((DeletePresenter) -> () -> Void)!
}
