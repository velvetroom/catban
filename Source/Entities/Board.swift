import Foundation

public class Board:TextProtocol, Codable {
    public var text:String
    public private(set) var columns:[Column]
    var syncstamp:Date
    
    init() {
        self.text = String()
        self.syncstamp = Date()
        self.columns = []
    }
    
    public func addColumn(text:String) {
        let column:Column = Column()
        column.text = text
        self.columns.append(column)
    }
    
    public func delete(column:Column) {
        self.columns.removeAll { (item:Column) -> Bool in item === column }
    }
}
