import Foundation

class LibraryStateDefault:LibraryStateProtocol {
    func loadSession(context:Library) throws {
        context.cache.load(session: { (session:Configuration.Session) in
            context.session = session
            context.sessionLoaded()
        }, error: { [weak self] (_:Error) in
            self?.loadSessionFailed(context:context)
        })
    }
    
    func loadBoards(context:Library) throws { throw DomainError.noSession }
    func newBoard(context:Library) throws { throw DomainError.noSession }
    
    private func loadSessionFailed(context:Library) {
        let session:Configuration.Session = Configuration.Session()
        context.session = session
        context.cache.save(session:session)
        context.sessionLoaded()
    }
}
