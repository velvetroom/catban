import Foundation

final public class Card:Codable {
    public var content = String()
    
    public required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy:CodingKeys.self)
        do {
            try content = values.decode(String.self, forKey:.content)
        } catch {
            try content = values.decode(String.self, forKey:.text)
        }
    }
    
    public func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(content, forKey:.content)
    }
    
    init() { }
    
    private enum CodingKeys:CodingKey {
        case text
        case content
    }
}
