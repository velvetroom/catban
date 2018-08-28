import XCTest
@testable import Catban

class TestLibrary_Boards:XCTestCase {
    private var library:Library!
    
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        library = Library()
    }
    
    func testAddBoardSavesSession() {
        let expect = expectation(description:String())
        (library.cache as! MockCache).onSaveSession = {
            XCTAssertFalse(self.library.session.boards.isEmpty)
            XCTAssertEqual("dsakaknaknfkj", self.library.session.boards.keys.first)
            expect.fulfill()
        }
        XCTAssertNoThrow(try library.addBoard(url:"iturbide.catban.dsakaknaknfkj"))
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testThrowsOnDuplicated() {
        library.session.boards["hello world"] = Board()
        XCTAssertThrowsError(try library.addBoard(url:"iturbide.catban.hello world"))
    }
    
    func testThrowsOnInvalid() {
        XCTAssertThrowsError(try library.addBoard(url:"hello world"))
    }
    
    func testSaveBoardCallsDatabase() {
        let expect = expectation(description:String())
        let board = Board()
        let originalSyncstamp = board.syncstamp
        library.session.boards["a"] = board
        (library.database as! MockDatabase).onSave = {
            XCTAssertNotEqual(originalSyncstamp, board.syncstamp)
            expect.fulfill()
        }
        library.save(board:board)
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testDeleteBoardCallsCache() {
        let expect = expectation(description:String())
        let board = Board()
        library.session.boards["a"] = board
        (library.cache as! MockCache).onSaveSession = {
            XCTAssertTrue(self.library.session.boards.isEmpty)
            XCTAssertTrue(self.library.boards.isEmpty)
            expect.fulfill()
        }
        library.delete(board:board)
        waitForExpectations(timeout:1, handler:nil)
    }
}
