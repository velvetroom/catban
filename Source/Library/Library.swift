import Foundation

public class Library {
    static let stateDefault:LibraryStateProtocol = LibraryStateDefault()
    static let stateReady:LibraryStateProtocol = LibraryStateReady()
    static let prefix:String = "iturbide.catban."
    
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
        self.state.newBoard(context:self)
    }
    
    public func addBoard(url:String) throws {
        try self.state.addBoard(context:self, url:url)
    }
    
    public func save(board:Board) {
        self.state.save(context:self, board:board)
    }
    
    public func delete(board:Board) {
        self.state.delete(context:self, board:board)
    }
    
    func loaded(session:Session) {
        self.session = session
        self.state = Library.stateReady
        DispatchQueue.main.async { [weak self] in self?.delegate?.librarySessionLoaded() }
    }
    
    func saveSession() {
        self.cache.save(session:self.session)
    }
    
    func notifyBoards() {
        DispatchQueue.main.async { [weak self] in self?.delegate?.libraryBoardsUpdated() }
    }
    
    func notifyCreated(board:String) {
        DispatchQueue.main.async { [weak self] in self?.delegate?.libraryCreated(board:board) }
    }
}

private struct Constants {
    static let identifier:String = "iturbide.catban.library"
}
