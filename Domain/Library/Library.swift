import Foundation

class Library:LibraryProtocol {
    static let stateDefault:LibraryStateProtocol = LibraryStateDefault()
    static let stateReady:LibraryStateProtocol = LibraryStateReady()
    
    weak var delegate:LibraryDelegate?
    weak var state:LibraryStateProtocol!
    var session:SessionProtocol
    var boards:[String:BoardProtocol]
    var cache:CacheServiceProtocol
    var database:DatabaseServiceProtocol
    let queue:DispatchQueue
    
    init() {
        self.session = Factory.makeSession()
        self.boards = [:]
        self.cache = Factory.makeCache()
        self.database = Factory.makeDatabase()
        self.queue = DispatchQueue(label:Constants.identifier, qos:DispatchQoS.background,
                                   attributes:DispatchQueue.Attributes(),
                                   autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency.inherit,
                                   target:DispatchQueue.global(qos:DispatchQoS.QoSClass.background))
        self.state = Library.stateDefault
    }
    
    func loadSession() throws {
        try self.state.loadSession(context:self)
    }
    
    func loadBoards() throws {
        try self.state.loadBoards(context:self)
    }
    
    func newBoard() throws {
        try self.state.newBoard(context:self)
    }
    
    func saveBoard(identifier:String) throws {
        try self.state.saveBoard(context:self, identifier:identifier)
    }
    
    func loaded(session:SessionProtocol) {
        self.session = session
        self.state = Library.stateReady
        DispatchQueue.main.async { [weak self] in self?.delegate?.librarySessionLoaded() }
    }
    
    func saveSession() {
        self.cache.save(session:self.session as! Configuration.Session)
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
