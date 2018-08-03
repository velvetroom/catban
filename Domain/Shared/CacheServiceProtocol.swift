import Foundation

public protocol CacheServiceProtocol {
    func load<M>(session:@escaping((M) -> Void), error:@escaping((Error) -> Void)) where M:Codable & SessionProtocol
    func load<M>(identifier:String, board:@escaping((M) -> Void)) where M:Codable & BoardProtocol
    func save<M>(session:M) where M:Codable & SessionProtocol
    func save<M>(identifier:String, board:M) where M:Codable & BoardProtocol
    init()
}
