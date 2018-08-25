import Foundation

public class Library {
    static let stateDefault:LibraryStateProtocol = LibraryStateDefault()
    static let stateReady:LibraryStateProtocol = LibraryStateReady()
    private static let prefix:String = "iturbide.catban."
    
    public weak var delegate:LibraryDelegate?
    public var boards:[String:Board] { get { return self.session.boards } }
    public var cardsFont:Int { get {
        return self.session.cardsFont
    } set(newValue) {
        self.session.cardsFont = newValue
        self.saveSession()
    } }
    public var defaultColumns:Bool { get {
        return self.session.defaultColumns
    } set(newValue) {
        self.session.defaultColumns = newValue
        self.saveSession()
    } }
    
    weak var state:LibraryStateProtocol!
    var session:Session
    var cache:CacheService
    var database:DatabaseService
    let queue:DispatchQueue
    
    init() {
        self.state = Library.stateDefault
        self.session = Session()
        self.cache = Factory.makeCache()
        self.database = Factory.makeDatabase()
        self.queue = DispatchQueue(label:Constants.identifier, qos:DispatchQoS.background,
                                   attributes:DispatchQueue.Attributes(),
                                   autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency.inherit,
                                   target:DispatchQueue.global(qos:DispatchQoS.QoSClass.background))
    }
    
    public func loadBoards() throws {
        try self.state.loadBoards(context:self)
    }
    
    public func loadSession() {
        self.state.loadSession(context:self)
    }
    
    public func newBoard() {
        queue.async {
            let board = Board()
            let identifier = self.database.create(board:board)
            self.session.boards[identifier] = board
            self.saveSession()
            DispatchQueue.main.async { self.delegate?.libraryCreated(board:identifier) }
        }
    }
    
    public func addBoard(url:String) throws {
        let identifier = try identifierFrom(url:url)
        try validate(identifier:identifier)
        session.boards[identifier] = Board()
        queue.async {
            self.saveSession()
        }
    }
    
    public func save(board:Board) {
        queue.async {
            guard let identifier = self.identifier(board:board) else { return }
            board.syncstamp = Date()
            self.database.save(identifier:identifier, board:board)
        }
    }
    
    public func delete(board:Board) {
        queue.async {
            guard
                let identifier = self.identifier(board:board) else { return }
            self.session.boards.removeValue(forKey:identifier)
            self.saveSession()
        }
    }
    
    public func url(identifier:String) -> String {
        return Library.prefix.appending(identifier)
    }
    
    private func saveSession() {
        self.cache.save(session:self.session)
    }
    
    private func identifier(board:Board) -> String? {
        return boards.first(where: { (_:String, value:Board) -> Bool in
            return board === value
        })?.key
    }
    
    private func identifierFrom(url:String) throws -> String {
        let components = url.components(separatedBy:Library.prefix)
        if components.count == 2 && !components[1].isEmpty {
            return components[1]
        } else {
            throw CatbanError.invalidBoardUrl
        }
    }
    
    private func validate(identifier:String) throws {
        if boards[identifier] != nil {
            throw CatbanError.boardAlreadyLoaded
        }
    }
}

private struct Constants {
    static let identifier:String = "iturbide.catban.library"
}
