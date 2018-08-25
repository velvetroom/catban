import Foundation

public class Session:Codable {
    public struct CardsFont {
        public static let original:Int = 14
        public static let min:Int = 8
        public static let max:Int = 30
    }
    
    public internal(set) var boards:[String:Board]
    public var cardsFont:Int
    public var defaultColumns:Bool
    
    public required init(from decoder:Decoder) throws {
        let values:KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy:CodingKeys.self)
        self.boards = [:]
        self.cardsFont = 0
        self.defaultColumns = true
        self.decodeBoards(values:values)
        self.decodeCardsFont(values:values)
        self.decodeDefaultColumns(values:values)
    }
    
    public func encode(to encoder:Encoder) throws {
        var container:KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(Array(self.boards.keys), forKey:CodingKeys.boards)
        try container.encode(self.cardsFont, forKey:CodingKeys.cardsFont)
        try container.encode(self.defaultColumns, forKey:CodingKeys.defaultColumns)
    }
    
    init() {
        self.boards = [:]
        self.cardsFont = CardsFont.original
        self.defaultColumns = true
    }
    
    private func decodeBoards(values:KeyedDecodingContainer<CodingKeys>) {
        let keys:[String]
        do { try keys = values.decode([String].self, forKey:CodingKeys.boards) } catch { return }
        keys.forEach { (key:String) in
            self.boards[key] = Board()
        }
    }
    
    private func decodeCardsFont(values:KeyedDecodingContainer<CodingKeys>) {
        do {
            try self.cardsFont = values.decode(Int.self, forKey:CodingKeys.cardsFont)
        } catch {
            self.cardsFont = CardsFont.original
        }
    }
    
    private func decodeDefaultColumns(values:KeyedDecodingContainer<CodingKeys>) {
        do { try self.defaultColumns = values.decode(Bool.self, forKey:CodingKeys.defaultColumns) } catch { }
    }
    
    private enum CodingKeys:CodingKey {
        case boards
        case cardsFont
        case defaultColumns
    }
}
