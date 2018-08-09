import Foundation

public protocol DatabaseServiceProtocol {
    func load<M>(identifier:String, board:@escaping((M) -> Void)) where M:Codable & BoardProtocol
    func create<M>(board:M) -> String where M:Codable & BoardProtocol
    func save<M>(identifier:String, board:M) where M:Codable & BoardProtocol
    
    init()
}
