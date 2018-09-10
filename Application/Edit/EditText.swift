import Foundation
import Catban

struct EditText {
    var title = String()
    var text = String()
    var board:Board!
    var column:Column!
    var card:Card!
    var save:((EditPresenter) -> (String) -> Void)!
}
