import XCTest
@testable import Catban

class TestBoard:XCTestCase {
    private var board:Board!
    
    override func setUp() {
        board = Board()
    }
    
    func testAddingColumn() {
        board.addColumn(text:"lorem ipsum")
        XCTAssertEqual(1, board.columns.count)
        XCTAssertEqual("lorem ipsum", board.columns.first?.text)
    }
    
    func testDeletingColumn() {
        let text = "hello world"
        board.addColumn(text:text)
        board.addColumn(text:"Another column")
        board.delete(column:board.columns.first!)
        XCTAssertEqual(1, board.columns.count)
        XCTAssertNotEqual(text, board.columns.first?.text)
    }
}
