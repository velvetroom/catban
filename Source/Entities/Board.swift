import Foundation

public class Board:TextProtocol, Codable {
    public var text = String()
    public private(set) var columns:[Column] = []
    var syncstamp = Date()
    
    public func addColumn(text:String) {
        let column = Column()
        column.text = text
        columns.append(column)
    }
    
    public func delete(column:Column) {
        columns.removeAll { (item) -> Bool in item === column }
    }
}
