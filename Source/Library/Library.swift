import Foundation

class Library:LibraryProtocol {
    static let stateDefault:LibraryStateProtocol = LibraryStateDefault()
    static let stateReady:LibraryStateProtocol = LibraryStateReady()
    
    weak var delegate:LibraryDelegate?
    weak var state:LibraryStateProtocol!
    var session:Session
    var cache:CacheService
    var database:DatabaseService
    let queue:DispatchQueue
    var boards:[String:Board] { get { return self.session.boards } }
    
    init() {
        self.state = Library.stateDefault
        self.session = Factory.makeSession()
        self.cache = Factory.makeCache()
        self.database = Factory.makeDatabase()
        self.queue = DispatchQueue(label:Constants.identifier, qos:DispatchQoS.background,
                                   attributes:DispatchQueue.Attributes(),
                                   autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency.inherit,
                                   target:DispatchQueue.global(qos:DispatchQoS.QoSClass.background))
    }
    
    func loadBoards() throws {
        try self.state.loadBoards(context:self)
    }
    
    func loadSession() {
        self.state.loadSession(context:self)
    }
    
    func newBoard() {
        self.state.newBoard(context:self)
    }
    
    func addBoard(identifier:String) {
        self.state.addBoard(context:self, identifier:identifier)
    }
    
    func save(board:Board) {
        self.state.save(context:self, board:board)
    }
    
    func delete(board:Board) {
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
