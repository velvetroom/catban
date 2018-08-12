import Foundation

public class Session:Codable {
    public private(set) var boards:[String:Board]
    
    public required init(from decoder:Decoder) throws {
        let values:KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy:CodingKeys.self)
        let keys:[String] = try values.decode([String].self, forKey:CodingKeys.boards)
        self.boards = [:]
        keys.forEach { (key:String) in
            self.boards[key] = Board()
        }
    }
    
    public func encode(to encoder:Encoder) throws {
        var container:KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(Array(self.boards.keys), forKey:CodingKeys.boards)
    }
    
    init() {
        self.boards = [:]
    }
    
    func add(board:String) {
        if self.boards[board] == nil {
            self.update(identifier:board, board:Board())
        }
    }
    
    func update(identifier:String, board:Board) {
        self.boards[identifier] = board
    }
    
    func remove(board:String) {
        self.boards.removeValue(forKey:board)
    }
    
    private enum CodingKeys:CodingKey {
        case boards
    }
}
