import Foundation

class LibraryStateReady:LibraryStateProtocol {
    func loadBoards(context:Library) throws {
        self.recursiveLoad(context:context, identifiers:Array(context.session.boards.keys))
    }
    
    func newBoard(context:Library) {
        context.queue.async {
            let board:Board = Board()
            let identifier:String = context.database.create(board:board)
            context.session.update(identifier:identifier, board:board)
            context.saveSession()
            context.notifyCreated(board:identifier)
        }
    }
    
    func addBoard(context:Library, identifier:String) {
        context.queue.async {
            context.session.add(board:identifier)
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
            context.session.remove(board:identifier)
            context.saveSession()
        }
    }
    
    func loadSession(context:Library) { }
    
    private func recursiveLoad(context:Library, identifiers:[String]) {
        context.queue.async { [weak self] in
            self?.load(context:context, identifiers:identifiers)
        }
    }
    
    private func load(context:Library, identifiers:[String]) {
        var identifiers:[String] = identifiers
        if let identifier:String = identifiers.popLast() {
            context.database.load(identifier:identifier) { [weak self] (board:Board) in
                context.session.update(identifier:identifier, board:board)
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
}
