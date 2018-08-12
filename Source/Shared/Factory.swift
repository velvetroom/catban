import Foundation

public class Factory {
    public class func makeLibrary() -> LibraryProtocol {
        if library == nil {
            library = Library()
        }
        return library
    }
    
    class func makeCache() -> CacheService {
        return Configuration.cache.init()
    }
    
    class func makeDatabase() -> DatabaseService {
        return Configuration.database.init()
    }
    
    private init() { }
    
    private static var library:LibraryProtocol!
}
