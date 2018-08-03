import XCTest
@testable import Domain

class TestSession:XCTestCase {
    private var session:Configuration.Session!
    private var library:Library!

    override func setUp() {
        super.setUp()
        Configuration.cacheService = MockCacheServiceProtocol.self
        Configuration.databaseService = MockDatabaseServiceProtocol.self
        self.session = Configuration.Session()
        self.library = Library()
    }

    func testSelectingBoard() {
        let boardA:Configuration.Board = Configuration.Board()
        let boardB:Configuration.Board = Configuration.Board()
        let boardC:Configuration.Board = Configuration.Board()
        self.library.boards["a"] = boardA
        self.library.boards["b"] = boardB
        self.library.boards["c"] = boardC
        XCTAssertThrowsError(try self.session.current(library:self.library), "Should be no selection")
        
        self.session.select(identifier:"b")
        var board:BoardProtocol!
        XCTAssertNoThrow(try board = self.session.current(library:self.library), "Failed to select")
        XCTAssertTrue(board === boardB, "Invalid board returned")
        
        self.session.clearSelection()
        XCTAssertThrowsError(try self.session.current(library:self.library), "Selection not cleared")
    }
}
