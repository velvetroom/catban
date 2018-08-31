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
        board.addColumn(text:"hello world")
        board.addColumn(text:"Another column")
        board.delete(column:board.columns.first!)
        XCTAssertEqual(1, board.columns.count)
        XCTAssertNotEqual("hello world", board.columns.first?.text)
    }
    
    func testMoveRight() {
        board.addColumn(text:"A")
        board.addColumn(text:"B")
        board.columns[0].addCard(text:"hello world")
        board.columns[1].addCard(text:"lorem ipsum")
        board.moveRight(card:board.columns[0].cards[0])
        XCTAssertTrue(board.columns[0].cards.isEmpty)
        XCTAssertEqual(2, board.columns[1].cards.count)
        XCTAssertEqual("hello world", board.columns[1].cards[0].text)
    }
}
