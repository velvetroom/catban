import Foundation

public struct Configuration:ConfigurationProtocol {
    typealias Session = Session_v1
    typealias Board = Board_v1
    
    public static var library:LibraryProtocol.Type = Library.self
    public static var cacheService:CacheServiceProtocol.Type!
    public static var databaseService:DatabaseServiceProtocol.Type!
}

private protocol ConfigurationProtocol {
    associatedtype Session:SessionProtocol
    associatedtype Board:BoardProtocol
}
