import Foundation

class LibraryReady:LibraryState {
    func loadSession(context:Library) { }
    
    func loadBoards(context:Library) throws {
        recursiveLoad(context:context, identifiers:Array(context.session.boards.keys))
    }
    
    func newBoard(context:Library) throws {
        context.queue.async { [weak self] in
            self?.createNewBoard(context:context)
        }
    }
    
    func addBoard(context:Library, url:String) throws {
        let identifier = try identifierFrom(url:url)
        try validate(context:context, identifier:identifier)
        context.session.boards[identifier] = Board()
        context.queue.async { context.saveSession() }
    }
    
    func merge(context:Library, boards:[String]) throws {
        context.queue.async { [weak self] in
            boards.forEach{ board in
                context.session.boards[board] = Board()
            }
            context.saveSession()
            try? self?.loadBoards(context:context)
        }
    }
    
    private func recursiveLoad(context:Library, identifiers:[String]) {
        context.queue.async { [weak self] in
            self?.load(context:context, identifiers:identifiers)
        }
    }
    
    private func load(context:Library, identifiers:[String]) {
        var identifiers = identifiers
        if let identifier = identifiers.popLast() {
            context.database.load(identifier:identifier, board: { [weak self] board in
                context.session.boards[identifier] = board
                self?.recursiveLoad(context:context, identifiers:identifiers)
            }) { [weak self] in
                self?.recursiveLoad(context:context, identifiers:identifiers)
            }
        } else {
            context.boardsUpdated()
        }
    }
    
    private func createNewBoard(context:Library) {
        let board = Board()
        let identifier = context.database.create(board:board)
        context.session.boards[identifier] = board
        context.session.counter += 1
        context.saveSession()
        DispatchQueue.main.async { context.delegate?.libraryCreated(board:identifier) }
    }
    
    private func identifierFrom(url:String) throws -> String {
        let components = url.components(separatedBy:"iturbide.catban.")
        if components.count == 2 && !components[1].isEmpty {
            return components[1]
        } else {
            throw CatbanError.invalidBoardUrl
        }
    }
    
    private func validate(context:Library, identifier:String) throws {
        if context.boards[identifier] != nil {
            throw CatbanError.boardAlreadyLoaded
        }
    }
}
