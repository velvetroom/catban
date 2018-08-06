import UIKit
import CleanArchitecture

struct BoardViewModel:ViewModel {
    var items:[BoardItemViewModel]
    var title:String
    
    init() {
        self.items = []
        self.title = String()
    }
}
