import Foundation

public class Column:Codable, TextProtocol {
    public var text:String
    public private(set) var cards:[Card]
    let identifier:String
    let created:Date
    
    init() {
        self.identifier = UUID().uuidString
        self.text = String()
        self.created = Date()
        self.cards = []
    }
    
    public func addCard(text:String) {
        let card:Card = Factory.makeCard()
        card.text = text
        self.cards.append(card)
    }
    
    public func delete(card:Card) {
        self.cards.removeAll { (item:Card) -> Bool in item === card }
    }
}
