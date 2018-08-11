import Foundation

public class Board:TextProtocol, Codable {
    public var text:String
    public var created:Date
    public var syncstamp:Date
    public var columns:[Column]
    
    init() {
        self.text = String()
        self.created = Date()
        self.syncstamp = Date()
        self.columns = []
    }
    
    public func addColumn(text:String) {
        let column:Column = Factory.makeColumn()
        column.text = text
        self.columns.append(column)
    }
    
    public func delete(column:Column) {
        self.columns.removeAll { (item:Column) -> Bool in item === column }
    }
}
