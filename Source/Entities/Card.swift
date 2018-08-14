import Foundation

public class Card:Codable, TextProtocol {
    public var text:String
    let identifier:String
    let created:Date
    
    init() {
        self.identifier = UUID().uuidString
        self.created = Date()
        self.text = String()
    }
}
