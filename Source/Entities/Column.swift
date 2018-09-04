import Foundation

final public class Column:Codable {
    public var name = String()
    public private(set) var cards:[Card] = []
    
    public required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy:CodingKeys.self)
        do {
            try name = values.decode(String.self, forKey:.name)
        } catch {
            try name = values.decode(String.self, forKey:.text)
        }
        try cards = values.decode([Card].self, forKey:.cards)
    }
    
    public func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(name, forKey:.name)
        try container.encode(cards, forKey:.cards)
    }
    
    init() { }
    
    private enum CodingKeys:CodingKey {
        case cards
        case text
        case name
    }
    
    public func addCard(text:String) {
        let card = Card()
        card.content = text
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
