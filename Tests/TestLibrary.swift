import XCTest
@testable import Catban

class TestLibrary:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    private var cache:MockCache!
    private var database:MockDatabase!
    
    override func setUp() {
        super.setUp()
        Configuration.cache = MockCache.self
        Configuration.database = MockDatabase.self
        self.library = Library()
        self.delegate = MockLibraryDelegate()
        self.library.delegate = self.delegate
        self.cache = self.library.cache as? MockCache
        self.database = self.library.database as? MockDatabase
        self.library.session = Factory.makeSession()
        self.library.state = Library.stateReady
    }
    
    func testLoadUpdatesSession() {
        self.library.state = Library.stateDefault
        let expect:XCTestExpectation = self.expectation(description:"Not loaded")
        self.library.session.add(board:String())
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
        self.library.session.add(board:String())
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
        self.library.session.add(board:"a")
        self.library.session.add(board:"b")
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
    
    func testAddBoardSavesSession() {
        let expect:XCTestExpectation = self.expectation(description:"Session not saved")
        self.cache.onSaveSession = {
            XCTAssertFalse(self.library.session.boards.isEmpty, "Failed to add board")
            expect.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            self.library.addBoard(identifier:String())
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testAddBoardNotRepeating() {
        let expect:XCTestExpectation = self.expectation(description:"Session not saved")
        let identifier:String = "hello world"
        self.library.session.add(board:identifier)
        self.cache.onSaveSession = {
            XCTAssertEqual(self.library.session.boards.count, 1, "Should be only 1 board")
            expect.fulfill()
        }
        self.library.addBoard(identifier:identifier)
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testSaveBoardCallsDatabase() {
        let board:Board = Factory.makeBoard()
        let originalSyncstamp:Date = board.syncstamp
        self.library.boards["a"] = board
        let expect:XCTestExpectation = self.expectation(description:"Not saved")
        self.database.onSave = {
            XCTAssertNotEqual(originalSyncstamp, board.syncstamp, "Failed to update syncstamp")
            expect.fulfill()
        }
        self.library.save(board:board)
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testDeleteBoardCallsCache() {
        let board:Board = Factory.makeBoard()
        let identifier:String = "a"
        self.library.session.add(board:identifier)
        self.library.boards[identifier] = board
        let expect:XCTestExpectation = self.expectation(description:"Not deleted")
        self.cache.onSaveSession = {
            XCTAssertTrue(self.library.session.boards.isEmpty, "Not removed from session")
            XCTAssertTrue(self.library.boards.isEmpty, "Not removed boards")
            expect.fulfill()
        }
        self.library.delete(board:board)
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
}
