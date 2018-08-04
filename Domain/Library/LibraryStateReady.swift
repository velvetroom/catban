import Foundation

class LibraryStateReady:LibraryStateProtocol {
    func loadBoards(context:Library) throws {
        context.queue.async { [weak self] in
            self?.load(context:context, identifiers:context.session.boards)
        }
    }
    
    func newBoard(context:Library) throws {
        context.queue.async {
            let board:Configuration.Board = Configuration.Board()
            board.name = Localized.string(key:"LibraryStateReady.boardName")
            let identifier:String = context.database.create(board:board)
            context.boards[identifier] = board
            context.session.boards.append(identifier)
            context.saveSession()
            context.notifyCreated(board:identifier)
        }
    }
    
    func save(context:Library, board:BoardProtocol) throws {
        context.queue.async {
            guard
                let identifier:String = context.boards.first(where: { (_:String, value:BoardProtocol) -> Bool in
                    return board === value })?.key,
                let board:Configuration.Board = board as? Configuration.Board
            else { return }
            board.syncstamp = Date()
            context.database.save(identifier:identifier, board:board)
        }
    }
    
    func loadSession(context:Library) throws { throw DomainError.sessionLoaded }
    
    private func load(context:Library, identifiers:[String]) {
        var identifiers:[String] = identifiers
        if let identifier:String = identifiers.popLast() {
            context.database.load(identifier:identifier) { [weak self] (board:Configuration.Board) in
                context.boards[identifier] = board
                context.queue.async { [weak self] in self?.load(context:context, identifiers:identifiers)  }
            }
        } else {
            context.notifyBoards()
        }
    }
}
