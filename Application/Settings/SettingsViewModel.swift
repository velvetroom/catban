import Foundation
import CleanArchitecture

struct SettingsViewModel:ViewModel {
    var cardsFont:Int
    var defaultColumns:Bool
    
    init() {
        self.cardsFont = 0
        self.defaultColumns = false
    }
}
