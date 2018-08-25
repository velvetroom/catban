import Foundation

class LibraryStateDefault:LibraryStateProtocol {
    func loadBoards(context:Library) throws { throw CatbanError.noSession }
    
    func loadSession(context:Library) {
        context.queue.async {
            do {
                let session:Session = try context.cache.loadSession()
                self.loaded(context:context, session:session)
            } catch {
                self.createSession(context:context)
            }
        }
    }
    
    private func createSession(context:Library) {
        let session:Session = Session()
        context.cache.save(session:session)
        loaded(context:context,session:session)
    }
    
    private func loaded(context:Library, session:Session) {
        context.session = session
        context.state = Library.stateReady
        DispatchQueue.main.async { context.delegate?.librarySessionLoaded() }
    }
}
