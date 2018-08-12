import XCTest
@testable import Catban

class TestBoard:XCTestCase {
    private var board:Board!
    
    override func setUp() {
        super.setUp()
        self.board = Board()
    }
    
    func testAddingColumn() {
        let text:String = "lorem ipsum"
        self.board.addColumn(text:text)
        XCTAssertEqual(self.board.columns.count, 1, "Not added")
        if self.board.columns.count == 1 {
            XCTAssertEqual(self.board.columns.first!.text, text, "Invalid text")
        }
    }
    
    func testDeletingColumn() {
        let text:String = "hello world"
        self.board.addColumn(text:text)
        guard let column:Column = self.board.columns.first else { return }
        self.board.addColumn(text:"Another column")
        self.board.delete(column:column)
        XCTAssertEqual(self.board.columns.count, 1, "Should have 1")
        XCTAssertNotEqual(text, self.board.columns.first?.text, "Removed wrong column")
    }
}
