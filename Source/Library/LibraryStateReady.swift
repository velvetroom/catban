import Foundation

class LibraryStateReady:LibraryStateProtocol {
    func loadBoards(context:Library) throws {
        self.recursiveLoad(context:context, identifiers:Array(context.session.boards.keys))
    }
    
    func newBoard(context:Library) {
        context.queue.async {
            let board:Board = Board()
            let identifier:String = context.database.create(board:board)
            context.session.boards[identifier] = board
            context.saveSession()
            context.notifyCreated(board:identifier)
        }
    }
    
    func addBoard(context:Library, url:String) throws {
        let identifier = try identifierFrom(url:url)
        try validate(context:context, identifier:identifier)
        context.session.boards[identifier] = Board()
        context.queue.async {
            context.saveSession()
        }
    }
    
    func save(context:Library, board:Board) {
        context.queue.async { [weak self] in
            guard let identifier:String = self?.identifier(context:context, board:board) else { return }
            board.syncstamp = Date()
            context.database.save(identifier:identifier, board:board)
        }
    }
    
    func delete(context:Library, board:Board) {
        context.queue.async { [weak self] in
            guard
                let identifier:String = self?.identifier(context:context, board:board)
            else { return }
            context.session.boards.removeValue(forKey:identifier)
            context.saveSession()
        }
    }
    
    private func recursiveLoad(context:Library, identifiers:[String]) {
        context.queue.async { [weak self] in
            self?.load(context:context, identifiers:identifiers)
        }
    }
    
    private func load(context:Library, identifiers:[String]) {
        var identifiers:[String] = identifiers
        if let identifier:String = identifiers.popLast() {
            context.database.load(identifier:identifier, board: { [weak self] (board:Board) in
                context.session.boards[identifier] = board
                self?.recursiveLoad(context:context, identifiers:identifiers)
            }) { [weak self] in
                self?.recursiveLoad(context:context, identifiers:identifiers)
            }
        } else {
            context.notifyBoards()
        }
    }
    
    private func identifier(context:Library, board:Board) -> String? {
        return context.boards.first(where: { (_:String, value:Board) -> Bool in
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
    
    private func validate(context:Library, identifier:String) throws {
        if context.boards[identifier] != nil {
            throw CatbanError.boardAlreadyLoaded
        }
    }
}
