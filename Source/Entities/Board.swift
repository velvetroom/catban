import Foundation

final public class Board:Editable, Codable {
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
