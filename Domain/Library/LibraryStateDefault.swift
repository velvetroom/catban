import Foundation

class LibraryStateDefault:LibraryStateProtocol {
    func loadSession(context:Library) throws {
        context.queue.async { [weak self] in
            do {
                let session:Session = try context.cache.loadSession()
                context.loaded(session:session)
            } catch {
                self?.createSession(context:context)
            }
        }
    }
    
    func loadBoards(context:Library) throws { throw DomainError.noSession }
    func newBoard(context:Library) throws { throw DomainError.noSession }
    func addBoard(context:Library, identifier:String) throws { throw DomainError.noSession }
    func save(context:Library, board:Board) throws { throw DomainError.noSession }
    func delete(context:Library, board:Board) throws { throw DomainError.noSession }
    
    private func createSession(context:Library) {
        let session:Session = Factory.makeSession()
        context.cache.save(session:session)
        context.loaded(session:session)
    }
}
