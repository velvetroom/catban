import Foundation

public protocol BoardProtocol:AnyObject {
    var name:String { get set }
    var created:Date { get set }
    var syncstamp:Date { get set }
    var columns:[Column] { get set }
}
