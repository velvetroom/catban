import Foundation
import Catban

struct EditText {
    var title = String()
    var other:Editable?
    var subject:Editable?
    var save:((EditPresenter) -> (String) -> Void)!
}
