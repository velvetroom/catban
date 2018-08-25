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
    
    private func createSession(context:Library) {
        let session:Session = Session()
        context.cache.save(session:session)
        context.loaded(session:session)
    }
}
