import Foundation

public protocol CacheServiceProtocol {
    func loadSession() throws -> Session
    func save(session:Session)
    init()
}
