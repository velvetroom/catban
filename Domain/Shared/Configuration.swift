import Foundation

public struct Configuration {
    public static var library:LibraryProtocol.Type = Library.self
    public static var cacheService:CacheServiceProtocol.Type!
    public static var databaseService:DatabaseServiceProtocol.Type!
}
