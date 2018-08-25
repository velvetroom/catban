import Foundation

class LibraryStateReady:LibraryStateProtocol {
    func loadBoards(context:Library) throws {
        self.recursiveLoad(context:context, identifiers:Array(context.session.boards.keys))
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
            DispatchQueue.main.async { context.delegate?.libraryBoardsUpdated() }
        }
    }
    
    func loadSession(context:Library) { }
}
