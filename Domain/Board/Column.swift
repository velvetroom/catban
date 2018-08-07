import Foundation

public class Column:Codable, NameProtocol {
    public var identifier:String
    public var name:String
    public var created:Date
    public var cards:[Card]
    
    init() {
        self.identifier = String()
        self.name = String()
        self.created = Date()
        self.cards = []
    }
}
