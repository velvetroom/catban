import Foundation

public class Factory {
    public static var cache:CacheService.Type!
    public static var database:DatabaseService.Type!
    private static var library:Library!
    
    public class func makeLibrary() -> Library {
        if library == nil { library = Library() }
        return library
    }
    
    class func makeCache() -> CacheService { return cache.init() }
    class func makeDatabase() -> DatabaseService { return database.init() }
    private init() { }
}
