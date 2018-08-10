import Foundation

public protocol CacheService {
    func loadSession() throws -> Session
    func save(session:Session)
    init()
}
