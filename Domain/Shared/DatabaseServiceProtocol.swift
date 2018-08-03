import Foundation

public protocol DatabaseServiceProtocol {
    func load<M>(identifier:String, board:@escaping((M) -> Void)) where M:Codable & BoardProtocol
    func create<M>(board:M, completion:@escaping((String) -> Void)) where M:Codable & BoardProtocol
    
    init()
}
