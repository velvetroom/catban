import Foundation
import Catban

protocol BoardState {
    func makeCard(drawer:BoardDrawer, column:Column, card:Card)
    func makeNewCard(drawer:BoardDrawer, column:Column)
    func makeNewColumn(drawer:BoardDrawer)
}
