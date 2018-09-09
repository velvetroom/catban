import XCTest
@testable import Catban

class TestLibrary_Default:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        library = Library()
        delegate = MockLibraryDelegate()
        library.delegate = delegate
        library.state = Library.stateDefault
    }
    
    func testLoadUpdatesSession() {
        let expect = expectation(description:String())
        library.session.boards[String()] = Board()
        delegate.onSessionLoaded = {
            XCTAssertTrue(self.library.session.boards.isEmpty)
            XCTAssertEqual(Thread.main, Thread.current)
            XCTAssertTrue(self.library.state === Library.stateReady)
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.library.loadSession() }
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testLoadCreatesSessionOnError() {
        let expectLoad = expectation(description:String())
        let expectSave = expectation(description:String())
        (library.cache as! MockCache).error = NSError()
        (library.cache as! MockCache).onSaveSession = { expectSave.fulfill() }
        library.session.boards[String()] = Board()
        delegate.onSessionLoaded = {
            XCTAssertTrue(self.library.session.boards.isEmpty)
            XCTAssertEqual(Thread.main, Thread.current)
            XCTAssertTrue(self.library.state === Library.stateReady)
            expectLoad.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.library.loadSession() }
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testNewBoardThrows() {
        XCTAssertThrowsError(try library.newBoard())
    }
    
    func testAddBoardThrows() {
        XCTAssertThrowsError(try library.addBoard(url:"iturbide.catban.hello"))
    }
}
