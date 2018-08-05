import UIKit
import CleanArchitecture

struct BoardViewModel:ViewModel {
    var items:[BoardCanvasItemView]
    var title:String
    
    init() {
        self.items = []
        self.title = String()
    }
}
