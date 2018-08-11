import XCTest
@testable import Catban

class TestBoard:XCTestCase {
    private var board:Board!
    
    override func setUp() {
        super.setUp()
        self.board = Factory.makeBoard()
    }
    
    func testAddingColumn() {
        let text:String = "lorem ipsum"
        self.board.addColumn(text:text)
        XCTAssertEqual(self.board.columns.count, 1, "Not added")
        if self.board.columns.count == 1 {
            XCTAssertEqual(self.board.columns.first!.text, text, "Invalid text")
        }
    }
}
