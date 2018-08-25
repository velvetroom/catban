import XCTest
@testable import Catban

class TestLibrary:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    private var cache:MockCache!
    private var database:MockDatabase!
    
    override func setUp() {
        super.setUp()
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        self.library = Library()
        self.delegate = MockLibraryDelegate()
        self.library.delegate = self.delegate
        self.cache = self.library.cache as? MockCache
        self.database = self.library.database as? MockDatabase
        self.library.session = Session()
        self.library.state = Library.stateReady
    }
    
    func testLoadUpdatesSession() {
        self.library.state = Library.stateDefault
        let expect:XCTestExpectation = self.expectation(description:"Not loaded")
        self.library.session.boards[String()] = Board()
        self.delegate.onSessionLoaded = {
            XCTAssertTrue(self.library.session.boards.isEmpty, "Session not updated")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            XCTAssertTrue(self.library.state === Library.stateReady, "Should be ready")
            expect.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            self.library.loadSession()
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testLoadCreatesSessionOnError() {
        self.library.state = Library.stateDefault
        let expectLoad:XCTestExpectation = self.expectation(description:"Not loaded")
        let expectSave:XCTestExpectation = self.expectation(description:"Not saved")
        self.cache.error = NSError()
        self.cache.onSaveSession = { expectSave.fulfill() }
        self.library.session.boards[String()] = Board()
        self.delegate.onSessionLoaded = {
            XCTAssertTrue(self.library.session.boards.isEmpty, "Session not updated")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            XCTAssertTrue(self.library.state === Library.stateReady, "Should be ready")
            expectLoad.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            self.library.loadSession()
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
        self.library.session.boards["a"] = Board()
        self.library.session.boards["b"] = Board()
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
            self.library.newBoard()
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
}
