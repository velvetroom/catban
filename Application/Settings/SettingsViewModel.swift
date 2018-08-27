import Foundation
import CleanArchitecture

struct SettingsViewModel:ViewModel {
    var cardsFont:Int
    var defaultColumns:Bool
    
    init() {
        cardsFont = 0
        defaultColumns = false
    }
}
