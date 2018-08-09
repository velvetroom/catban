import Foundation

public class Factory {
    public class func makeLibrary() -> LibraryProtocol {
        if library == nil {
            library = Library()
        }
        return library
    }
    
    public class func makeColumn() -> Column {
        let column:Column = Column()
        column.identifier = UUID().uuidString
        return column
    }
    
    public class func makeCard() -> Card {
        let card:Card = Card()
        card.identifier = UUID().uuidString
        return card
    }
    
    class func makeSession() -> SessionProtocol {
        return Configuration.Session()
    }
    
    class func makeBoard() -> BoardProtocol {
        return Configuration.Board()
    }
    
    class func makeCache() -> CacheServiceProtocol {
        return Configuration.cacheService.init()
    }
    
    class func makeDatabase() -> DatabaseServiceProtocol {
        return Configuration.databaseService.init()
    }
    
    private init() { }
    
    private static var library:LibraryProtocol!
}
