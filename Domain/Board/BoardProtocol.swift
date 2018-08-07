import Foundation

public protocol BoardProtocol:AnyObject, TextProtocol {
    var created:Date { get set }
    var syncstamp:Date { get set }
    var columns:[Column] { get set }
}
