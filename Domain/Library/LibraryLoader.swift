import Foundation

class LibraryLoader {
    weak var library:Library?
    var timeout:TimeInterval
    private var identifiers:[String]
    private var boards:[String:BoardProtocol]
    private let group:DispatchGroup
    private let queue:DispatchQueue
    
    init() {
        self.timeout = Constants.timeout
        self.identifiers = []
        self.boards = [:]
        self.group = DispatchGroup()
        self.queue = DispatchQueue(label:Constants.identifier, qos:DispatchQoS.background,
                                   attributes:DispatchQueue.Attributes(),
                                   autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency.inherit,
                                   target:DispatchQueue.global(qos:DispatchQoS.QoSClass.background))
        self.group.setTarget(queue:self.queue)
    }
    
    func load(identifiers:[String]) {
        self.queue.async { [weak self] in
            self?.boards = [:]
            self?.identifiers = identifiers
            self?.next()
        }
    }
    
    private func next() {
        if let identifier:String = self.identifiers.first {
            self.identifiers.removeFirst()
            self.loadRemote(identifier:identifier)
        } else {
            self.library?.boards = boards
            self.library?.notifyBoards()
        }
    }
    
    private func loadRemote(identifier:String) {
        //self.group.enter()
        self.library?.database.load(identifier:identifier) { [weak self] (board:Configuration.Board) in
            self?.loaded(identifier:identifier, remote:board)
        }
//        if group.wait(timeout:DispatchTime.now() + self.timeout) == DispatchTimeoutResult.timedOut {
//            self.timedout(identifier:identifier)
//        }
    }
    
    private func loaded(identifier:String, remote:Configuration.Board) {
//        self.group.leave()
        self.library?.cache.save(identifier:identifier, board:remote)
        self.loaded(identifier:identifier, board:remote)
    }
    
    private func timedout(identifier:String) {
        self.library?.cache.load(identifier:identifier) { [weak self] (board:Configuration.Board) in
            self?.loaded(identifier:identifier, board:board)
        }
    }
    
    private func loaded(identifier:String, board:BoardProtocol) {
        self.queue.async { [weak self] in
            self?.boards[identifier] = board
            self?.next()
        }
    }
}

private struct Constants {
    static let identifier:String = "iturbide.catban.libraryBoardsLoader"
    static let timeout:TimeInterval = 5
}
