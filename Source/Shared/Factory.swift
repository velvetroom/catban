import Foundation

public class Factory {
    public class func makeLibrary() -> LibraryProtocol {
        if library == nil {
            library = Library()
        }
        return library
    }
    
    class func makeBoard() -> Board {
        return Board()
    }
    
    class func makeColumn() -> Column {
        return Column()
    }
    
    class func makeCard() -> Card {
        return Card()
    }
    
    class func makeSession() -> Session {
        return Session()
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
