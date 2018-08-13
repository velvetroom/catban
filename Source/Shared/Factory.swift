import Foundation

public class Factory {
    public static var cache:CacheService.Type!
    public static var database:DatabaseService.Type!
    
    public class func makeLibrary() -> LibraryProtocol {
        if library == nil {
            library = Library()
        }
        return library
    }
    
    public class func makeReport() -> ReportProtocol {
        return Report()
    }
    
    class func makeCache() -> CacheService {
        return cache.init()
    }
    
    class func makeDatabase() -> DatabaseService {
        return database.init()
    }
    
    private init() { }
    
    private static var library:LibraryProtocol!
}
