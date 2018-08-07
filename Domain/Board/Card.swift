import Foundation

public class Card:Codable {
    public var identifier:String
    public var created:Date
    public var content:String
    
    init() {
        self.identifier = String()
        self.created = Date()
        self.content = String()
    }
}
