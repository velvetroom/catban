import Foundation

public class Card:Codable, TextProtocol {
    public var identifier:String
    public var created:Date
    public var text:String
    
    init() {
        self.identifier = String()
        self.created = Date()
        self.text = String()
    }
}
