import Foundation

class LibraryStateReady:LibraryStateProtocol {
    func loadBoards(context:Library) throws {
        context.loader.load(identifiers:context.session.boards)
    }
    
    func newBoard(context:Library) throws {
        let board:Configuration.Board = Configuration.Board()
        context.database.create(board:board) { (identifier:String) in
            context.boards[identifier] = board
            context.session.boards.append(identifier)
            context.cache.save(identifier:identifier, board:board)
            context.saveSession()
            context.notifyBoards()
        }
    }
    
    func loadSession(context:Library) throws { throw DomainError.sessionLoaded }
}
