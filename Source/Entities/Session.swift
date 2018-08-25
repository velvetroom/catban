import Foundation

public class Session:Codable {
    public internal(set) var boards:[String:Board]
    public var cardsFont:Int
    public var defaultColumns:Bool
    static let cardsFont:Int = 14
    
    public required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy:CodingKeys.self)
        boards = [:]
        cardsFont = 0
        defaultColumns = true
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
    
    init() {
        boards = [:]
        cardsFont = Session.cardsFont
        defaultColumns = true
    }
    
    private func decodeBoards(values:KeyedDecodingContainer<CodingKeys>) {
        let keys:[String]
        do { try keys = values.decode([String].self, forKey:.boards) } catch { return }
        keys.forEach { (key) in
            boards[key] = Board()
        }
    }
    
    private func decodeCardsFont(values:KeyedDecodingContainer<CodingKeys>) {
        do {
            try cardsFont = values.decode(Int.self, forKey:.cardsFont)
        } catch {
            cardsFont = Session.cardsFont
        }
    }
    
    private func decodeDefaultColumns(values:KeyedDecodingContainer<CodingKeys>) {
        do { try defaultColumns = values.decode(Bool.self, forKey:.defaultColumns) } catch { }
    }
    
    private enum CodingKeys:CodingKey {
        case boards
        case cardsFont
        case defaultColumns
    }
}
