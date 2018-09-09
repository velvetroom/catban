import XCTest
@testable import Catban

class TestLibrary_Merge:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        library = Library()
        delegate = MockLibraryDelegate()
        library.delegate = delegate
        library.state = Library.stateReady
    }
    
    /*
    func testAddsNewBoards() {
        let expect = expectation(description:String())
        (library.cache as! MockCache).onSaveSession = {
            XCTAssertFalse(self.library.session.boards.isEmpty)
            XCTAssertEqual("dsakaknaknfkj", self.library.session.boards.keys.first)
            expect.fulfill()
        }
        XCTAssertNoThrow(try library.addBoard(url:"iturbide.catban.dsakaknaknfkj"))
        waitForExpectations(timeout:1, handler:nil)
    }*/
}
