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
    
    public func delete(column:Column) {
        self.columns.removeAll { (item:Column) -> Bool in item === column }
    }
}
