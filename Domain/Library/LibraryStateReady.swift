import Foundation

class LibraryStateReady:LibraryStateProtocol {
    func loadBoards(context:Library) throws {
        context.queue.async { [weak self] in
            self?.load(context:context, identifiers:context.session.boards)
        }
    }
    
    func newBoard(context:Library) throws {
        context.queue.async {
            let board:Board = Board()
            let identifier:String = context.database.create(board:board)
            context.boards[identifier] = board
            context.session.boards.append(identifier)
            context.saveSession()
            context.notifyCreated(board:identifier)
        }
    }
    
    func addBoard(context:Library, identifier:String) throws {
        context.queue.async {
            if !context.session.boards.contains(identifier) {
                context.session.boards.append(identifier)
            }
            context.saveSession()
        }
    }
    
    func save(context:Library, board:Board) throws {
        context.queue.async { [weak self] in
            guard let identifier:String = self?.identifier(context:context, board:board) else { return }
            board.syncstamp = Date()
            context.database.save(identifier:identifier, board:board)
        }
    }
    
    func delete(context:Library, board:Board) throws {
        context.queue.async { [weak self] in
            guard
                let identifier:String = self?.identifier(context:context, board:board)
            else { return }
            context.boards.removeValue(forKey:identifier)
            context.session.boards.removeAll { (item:String) -> Bool in
                item == identifier
            }
            context.saveSession()
        }
    }
    
    func loadSession(context:Library) throws { throw DomainError.sessionLoaded }
    
    private func load(context:Library, identifiers:[String]) {
        var identifiers:[String] = identifiers
        if let identifier:String = identifiers.popLast() {
            context.database.load(identifier:identifier) { [weak self] (board:Board) in
                context.boards[identifier] = board
                context.queue.async { [weak self] in self?.load(context:context, identifiers:identifiers)  }
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
}
