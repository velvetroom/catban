import Foundation

class LibraryStateDefault:LibraryStateProtocol {
    func loadSession(context:Library) {
        context.queue.async { [weak self] in
            do {
                let session:Session = try context.cache.loadSession()
                context.loaded(session:session)
            } catch {
                self?.createSession(context:context)
            }
        }
    }
    
    func loadBoards(context:Library) throws { throw CatbanError.noSession }
    func newBoard(context:Library) { }
    func addBoard(context:Library, identifier:String) { }
    func save(context:Library, board:Board) { }
    func delete(context:Library, board:Board) { }
    
    private func createSession(context:Library) {
        let session:Session = Factory.makeSession()
        context.cache.save(session:session)
        context.loaded(session:session)
    }
}
