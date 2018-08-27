import Foundation
import Catban

struct EditText {
    var title = String()
    var other:TextProtocol?
    var subject:TextProtocol?
    var save:((EditPresenter) -> (String) -> Void)!
}
