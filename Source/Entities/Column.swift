import Foundation

public class Column:Codable, TextProtocol {
    public var identifier:String
    public var text:String
    public var created:Date
    public var cards:[Card]
    
    init() {
        self.identifier = String()
        self.text = String()
        self.created = Date()
        self.cards = []
    }
    
    public func delete(card:Card) {
        self.cards.removeAll { (item:Card) -> Bool in item === card }
    }
}
