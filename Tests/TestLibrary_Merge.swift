import XCTest
@testable import Catban

class TestLibrary_Merge:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    private var cache:MockCache!
    
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        library = Library()
        delegate = MockLibraryDelegate()
        cache = library.cache as? MockCache
        library.delegate = delegate
        library.state = Library.stateReady
    }
    
    func testAddsNewBoards() {
        let expectSave = expectation(description:String())
        let expectUpdate = expectation(description:String())
        cache.onSaveSession = {
            XCTAssertEqual(2, self.library.session.boards.count)
            XCTAssertNotNil(self.library.session.boards["hello world"])
            XCTAssertNotNil(self.library.session.boards["lorem ipsum"])
            expectSave.fulfill()
        }
        delegate.onBoardsUpdated = { expectUpdate.fulfill() }
        XCTAssertNoThrow(try library.merge(boards:["hello world", "lorem ipsum"]))
        waitForExpectations(timeout:1)
    }
    
    func testNotRepeating() {
        let expect = expectation(description:String())
        cache.onSaveSession = {
            XCTAssertEqual(1, self.library.session.boards.count)
            expect.fulfill()
        }
        library.session.boards["hello world"] = Board()
        XCTAssertNoThrow(try library.merge(boards:["hello world"]))
        waitForExpectations(timeout:1)
    }
}
