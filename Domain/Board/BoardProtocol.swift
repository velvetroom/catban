import Foundation

public protocol BoardProtocol:AnyObject, TextProtocol {
    var created:Date { get set }
    var syncstamp:Date { get set }
    var columns:[Column] { get set }
}

public extension BoardProtocol {
    func delete(column:Column) {
        self.columns.removeAll { (item:Column) -> Bool in item === column }
    }
}
