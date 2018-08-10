import Foundation

public struct Configuration {
    public static var library:LibraryProtocol.Type = Library.self
    public static var cache:CacheService.Type!
    public static var database:DatabaseService.Type!
}
