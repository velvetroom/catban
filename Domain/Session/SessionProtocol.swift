import Foundation

public protocol SessionProtocol:AnyObject {
    var boards:[String] { get set }
    
    func current(library:LibraryProtocol) throws -> BoardProtocol
    func select(identifier:String)
    func clearSelection()
}
