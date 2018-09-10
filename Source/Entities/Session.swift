import Foundation

public class Session:Codable {
    public internal(set) var boards:[String:Board] = [:]
    public var cardsFont:Int = Session.cardsFont
    public var defaultColumns = true
    static let cardsFont:Int = 14
    
    public required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy:CodingKeys.self)
        decodeBoards(values:values)
        decodeCardsFont(values:values)
        decodeDefaultColumns(values:values)
    }
    
    public func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(Array(boards.keys), forKey:.boards)
        try container.encode(cardsFont, forKey:.cardsFont)
        try container.encode(defaultColumns, forKey:.defaultColumns)
    }
    
    init() { }
    
    private func decodeBoards(values:KeyedDecodingContainer<CodingKeys>) {
        if let keys = try? values.decode([String].self, forKey:.boards) {
            keys.forEach { key in
                boards[key] = Board()
            }
        }
    }
    
    private func decodeCardsFont(values:KeyedDecodingContainer<CodingKeys>) {
        try? cardsFont = values.decode(Int.self, forKey:.cardsFont)
    }
    
    private func decodeDefaultColumns(values:KeyedDecodingContainer<CodingKeys>) {
        try? defaultColumns = values.decode(Bool.self, forKey:.defaultColumns)
    }
    
    private enum CodingKeys:CodingKey {
        case boards
        case cardsFont
        case defaultColumns
    }
}
