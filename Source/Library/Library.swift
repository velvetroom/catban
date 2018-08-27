import Foundation

public class Library {
    public weak var delegate:LibraryDelegate?
    public var boards:[String:Board] { return session.boards }
    public var cardsFont:Int { get {
        return session.cardsFont
    } set(newValue) {
        session.cardsFont = newValue
        saveSession()
    } }
    public var defaultColumns:Bool { get {
        return session.defaultColumns
    } set(newValue) {
        session.defaultColumns = newValue
        saveSession()
    } }
    var session = Session()
    var cache = Factory.makeCache()
    var database = Factory.makeDatabase()
    var state:LibraryStateProtocol = Library.stateDefault
    let queue = DispatchQueue(label:Library.prefix, qos:.background, target:.global(qos:.background))
    static let stateDefault = LibraryStateDefault()
    static let stateReady = LibraryStateReady()
    private static let prefix = "iturbide.catban."
    
    public func loadBoards() throws {
        try state.loadBoards(context:self)
    }
    
    public func loadSession() {
        state.loadSession(context:self)
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
            guard let identifier = self.identifier(board:board) else { return }
            self.session.boards.removeValue(forKey:identifier)
            self.saveSession()
        }
    }
    
    public func url(identifier:String) -> String {
        return Library.prefix.appending(identifier)
    }
    
    func saveSession() {
        cache.save(session:session)
    }
    
    private func identifier(board:Board) -> String? {
        return boards.first(where: { (_, value) -> Bool in return board === value } )?.key
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
