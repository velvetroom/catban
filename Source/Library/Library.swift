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
    var state:LibraryState = Library.stateDefault
    let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    static let stateDefault = LibraryDefault()
    static let stateReady = LibraryReady()
    
    public func loadBoards() throws {
        try state.loadBoards(context:self)
    }
    
    public func loadSession() {
        state.loadSession(context:self)
    }
    
    public func newBoard() throws {
        try state.newBoard(context:self)
    }
    
    public func addBoard(url:String) throws {
        try state.addBoard(context:self, url:url)
    }
    
    public func merge(boards:[String]) throws {
        try state.merge(context:self, boards:boards)
    }
    
    public func change(skin:Skin) throws {
        try state.change(context:self, skin:skin)
    }
    
    public func save(board:Board) {
        queue.async { [weak self] in
            guard let identifier = self?.identifier(board:board) else { return }
            board.syncstamp = Date()
            self?.database.save(identifier:identifier, board:board)
        }
    }
    
    public func delete(board:Board) {
        queue.async { [weak self] in
            guard let identifier = self?.identifier(board:board) else { return }
            self?.session.boards.removeValue(forKey:identifier)
            self?.saveSession()
            self?.boardsUpdated()
        }
    }
    
    public func url(identifier:String) -> String {
        return "iturbide.catban.".appending(identifier)
    }
    
    public func rate() -> Bool {
        var rating = false
        if session.counter > 1 {
            if let last = session.rates.last,
                let months = Calendar.current.dateComponents([.month], from:last, to:Date()).month {
                rating = months < -2
            } else {
                rating = true
            }
        }
        if rating {
            session.rates.append(Date())
        }
        return rating
    }
    
    func saveSession() {
        cache.save(session:session)
    }
    
    func boardsUpdated() {
        DispatchQueue.main.async { [weak self] in self?.delegate?.libraryBoardsUpdated() }
    }
    
    private func identifier(board:Board) -> String? {
        return boards.first { _, value in board === value }?.key
    }
}
