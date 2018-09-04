import Foundation

final public class Board:Codable {
    public var name = String()
    public private(set) var columns:[Column] = []
    var syncstamp = Date()
    
    public required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy:CodingKeys.self)
        do {
            try name = values.decode(String.self, forKey:.name)
        } catch {
            try name = values.decode(String.self, forKey:.text)
        }
        try columns = values.decode([Column].self, forKey:.columns)
        try syncstamp = values.decode(Date.self, forKey:.syncstamp)
    }
    
    public func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(name, forKey:.name)
        try container.encode(columns, forKey:.columns)
        try container.encode(syncstamp, forKey:.syncstamp)
    }
    
    init() { }
    
    private enum CodingKeys:CodingKey {
        case columns
        case syncstamp
        case text
        case name
    }
    
    public func addColumn(text:String) {
        let column = Column()
        column.name = text
        columns.append(column)
    }
    
    public func delete(column:Column) {
        columns.removeAll { (item) -> Bool in item === column }
    }
    
    public func moveRight(card:Card) {
        for index in 0 ..< columns.count - 1 {
            if let _ = columns[index].cards.first(where: { (item) -> Bool in item === card }) {
                columns[index].delete(card:card)
                columns[index + 1].makeFirst(card:card)
                break
            }
        }
    }
}
