import Foundation

public protocol CacheServiceProtocol {
    func loadSession<M>() throws -> M where M:Codable & SessionProtocol
    func save<M>(session:M) where M:Codable & SessionProtocol
    init()
}
