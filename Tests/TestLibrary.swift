import XCTest
@testable import Domain

class TestLibrary:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    private var cache:MockCacheServiceProtocol!
    private var database:MockDatabaseServiceProtocol!
    
    override func setUp() {
        super.setUp()
        Configuration.cacheService = MockCacheServiceProtocol.self
        Configuration.databaseService = MockDatabaseServiceProtocol.self
        self.library = Library()
        self.delegate = MockLibraryDelegate()
        self.library.delegate = self.delegate
        self.cache = self.library.cache as? MockCacheServiceProtocol
        self.database = self.library.database as? MockDatabaseServiceProtocol
        self.library.session = Factory.makeSession()
        self.library.state = Library.stateReady
    }
    
    func testLoadUpdatesSession() {
        self.library.state = Library.stateDefault
        let expect:XCTestExpectation = self.expectation(description:"Not loaded")
        self.library.session.boards.append(String())
        self.delegate.onSessionLoaded = {
            XCTAssertTrue(self.library.session.boards.isEmpty, "Session not updated")
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
        self.library.state = Library.stateDefault
        let expectLoad:XCTestExpectation = self.expectation(description:"Not loaded")
        let expectSave:XCTestExpectation = self.expectation(description:"Not saved")
        self.cache.error = NSError()
        self.cache.onSaveSession = { expectSave.fulfill() }
        self.library.session.boards.append(String())
        self.delegate.onSessionLoaded = {
            XCTAssertTrue(self.library.session.boards.isEmpty, "Session not updated")
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
        let expectLoad:XCTestExpectation = self.expectation(description:"Not loaded")
        let expectCreate:XCTestExpectation = self.expectation(description:"Board not created on remote")
        let expectSaveSession:XCTestExpectation = self.expectation(description:"Session not saved")
        self.database.onCreate = { expectCreate.fulfill() }
        self.cache.onSaveSession = { expectSaveSession.fulfill() }
        self.delegate.onCreated = {
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
    
    func testSaveBoardCallsDatabase() {
        let identifier:String = "hello"
        self.library.boards[identifier] = Factory.makeBoard()
        let expect:XCTestExpectation = self.expectation(description:"Not saved")
        self.database.onSave = { expect.fulfill() }
        do { try self.library.saveBoard(identifier:identifier) } catch { }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
}
