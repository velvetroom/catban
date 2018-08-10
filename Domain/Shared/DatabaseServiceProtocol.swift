import Foundation

public protocol DatabaseServiceProtocol {
    func load(identifier:String, board:@escaping((Board) -> Void))
    func create(board:Board) -> String
    func save(identifier:String, board:Board)
    
    init()
}
