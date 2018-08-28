import Foundation

class LibraryStateDefault:LibraryStateProtocol {
    func loadBoards(context:Library) throws { throw CatbanError.noSession }
    
    func loadSession(context:Library) {
        context.queue.async {
            do {
                self.loaded(context:context, session:try context.cache.loadSession())
            } catch {
                self.loaded(context:context, session:Session())
            }
        }
    }
    
    private func loaded(context:Library, session:Session) {
        context.session = session
        context.saveSession()
        context.state = Library.stateReady
        DispatchQueue.main.async { context.delegate?.librarySessionLoaded() }
    }
}
