import Foundation

final public class Column:Editable, Codable {
    public var text = String()
    public private(set) var cards:[Card] = []
    
    public func addCard(text:String) {
        let card = Card()
        card.text = text
        cards.append(card)
    }
    
    public func delete(card:Card) {
        cards.removeAll { (item) -> Bool in item === card }
    }
    
    public func insert(card:Card, after:Card) {
        for index in 0 ..< cards.count {
            if cards[index] === after {
                cards.insert(card, at:index + 1)
                break
            }
        }
    }
    
    public func makeFirst(card:Card) {
        cards.insert(card, at:0)
    }
}
