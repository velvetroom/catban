import XCTest
@testable import Domain

class TestsLibrary:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    private var repository:MockCacheServiceProtocol!
    private var database:MockDatabaseServiceProtocol!
    
    override func setUp() {
        super.setUp()
        Configuration.cacheService = MockCacheServiceProtocol.self
        Configuration.databaseService = MockDatabaseServiceProtocol.self
        self.library = Library()
        self.delegate = MockLibraryDelegate()
        self.library.delegate = self.delegate
        self.repository = self.library.cache as? MockCacheServiceProtocol
        self.database = self.library.database as? MockDatabaseServiceProtocol
        self.library.session = Factory.makeSession()
        self.library.state = Library.stateDefault
    }
    
    func testSessionStartsWithNullObject() {
        let sessionNil:SessionNil? = Library().session as? SessionNil
        XCTAssertNotNil(sessionNil, "Session is not the null object")
    }
    
    func testLoadUpdatesSession() {
        let expect:XCTestExpectation = self.expectation(description:"Not loaded")
        self.delegate.onSessionLoaded = {
            let sessionNil:SessionNil? = self.library.session as? SessionNil
            XCTAssertNil(sessionNil, "Session not loaded")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            XCTAssertTrue(self.library.state === Library.stateReady, "Should be ready")
            expect.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            do { try self.library.loadSession() } catch {}
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testLoadCreatesSessionOnError() {
        let expectLoad:XCTestExpectation = self.expectation(description:"Not loaded")
        let expectSave:XCTestExpectation = self.expectation(description:"Not saved")
        self.repository.error = NSError()
        self.repository.onSaveSession = { expectSave.fulfill() }
        self.delegate.onSessionLoaded = {
            let sessionNil:SessionNil? = self.library.session as? SessionNil
            XCTAssertNil(sessionNil, "Session not loaded")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            XCTAssertTrue(self.library.state === Library.stateReady, "Should be ready")
            expectLoad.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            do { try self.library.loadSession() } catch {}
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testLoadUpdatesEmptyBoards() {
        self.library.state = Library.stateReady
        let expect:XCTestExpectation = self.expectation(description:"Not loaded")
        self.delegate.onBoardsUpdated = {
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            expect.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            do { try self.library.loadBoards() } catch {}
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testLoadUpdatesNonEmptyBoards() {
        self.library.state = Library.stateReady
        let expect:XCTestExpectation = self.expectation(description:"Not loaded")
        self.library.session.boards = ["a", "b"]
        self.delegate.onBoardsUpdated = {
            XCTAssertEqual(self.library.boards.count, self.library.session.boards.count, "Invalid amount")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            expect.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            do { try self.library.loadBoards() } catch {}
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testNewBoardAddsBoardAndNotifiesDelegate() {
        self.library.state = Library.stateReady
        let expectLoad:XCTestExpectation = self.expectation(description:"Not loaded")
        let expectCreate:XCTestExpectation = self.expectation(description:"Board not created on remote")
        let expectSaveBoard:XCTestExpectation = self.expectation(description:"Board not saved")
        let expectSaveSession:XCTestExpectation = self.expectation(description:"Session not saved")
        self.database.onCreate = { expectCreate.fulfill() }
        self.repository.onSaveBoard = { expectSaveBoard.fulfill() }
        self.repository.onSaveSession = { expectSaveSession.fulfill() }
        self.delegate.onBoardsUpdated = {
            XCTAssertFalse(self.library.session.boards.isEmpty, "Not added to session")
            XCTAssertFalse(self.library.boards.isEmpty, "Board not added")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            expectLoad.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            do { try self.library.newBoard() } catch {}
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testLoadFromCacheOnDatabaseError() {
        self.library.state = Library.stateReady
        self.library.loader.timeout = 0
        let expect:XCTestExpectation = self.expectation(description:"Not loaded")
        self.database.error = NSError()
        self.library.session.boards = [String()]
        self.delegate.onBoardsUpdated = {
            XCTAssertEqual(self.library.boards.count, self.library.session.boards.count, "Invalid amount")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            expect.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            do { try self.library.loadBoards() } catch {}
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testLoadRemoteSavesToCache() {
        self.library.state = Library.stateReady
        let expectLoaded:XCTestExpectation = self.expectation(description:"Not loaded")
        let expectSaved:XCTestExpectation = self.expectation(description:"Not saved")
        self.library.session.boards = [String()]
        self.repository.onSaveBoard = { expectSaved.fulfill() }
        self.delegate.onBoardsUpdated = {
            expectLoaded.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            do { try self.library.loadBoards() } catch {}
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
}
