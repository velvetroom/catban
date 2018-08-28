import Foundation
import Catban

class BoardStateSearch:BoardState {
    private let text:String
    
    init(text:String) {
        self.text = text
    }
    
    func makeCard(drawer:BoardDrawer, column:Column, card:Card) {
        if card.text.localizedCaseInsensitiveContains(text) {
            drawer.makeCard(column:column, card:card)
        }
    }
    
    func makeNewCard(drawer:BoardDrawer, column:Column) { }
    func makeNewColumn(drawer:BoardDrawer) { }
}
