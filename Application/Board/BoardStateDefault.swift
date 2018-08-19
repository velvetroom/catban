import Foundation
import Catban

class BoardStateDefault:BoardState {
    func makeCard(drawer:BoardDrawer, column:Column, card:Card) {
        drawer.makeCard(column:column, card:card)
    }
    
    func makeNewCard(drawer:BoardDrawer, column:Column) {
        drawer.makeNewCard(column:column)
    }
    
    func makeNewColumn(drawer:BoardDrawer) {
        drawer.makeNewColumn()
    }
}
