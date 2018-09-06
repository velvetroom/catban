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
        XCTAssertEqual("lorem ipsum", board.columns.first?.name)
    }
    
    func testDeletingColumn() {
        board.addColumn(text:"hello world")
        board.addColumn(text:"Another column")
        board.delete(column:board.columns.first!)
        XCTAssertEqual(1, board.columns.count)
        XCTAssertNotEqual("hello world", board.columns.first?.name)
    }
    
    func testMoveRight() {
        board.addColumn(text:"A")
        board.addColumn(text:"B")
        board.columns[0].addCard(text:"hello world")
        board.columns[1].addCard(text:"lorem ipsum")
        board.moveRight(card:board.columns[0].cards[0])
        XCTAssertTrue(board.columns[0].cards.isEmpty)
        XCTAssertEqual(2, board.columns[1].cards.count)
        XCTAssertEqual("hello world", board.columns[1].cards[0].content)
    }
    
    func testLoadLegacyBoard() {
        guard
            let data = try? JSONSerialization.data(withJSONObject:["text":"hello world", "cards":[]]),
            let column = try? JSONDecoder().decode(Column.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual("hello world", column.name)
    }
    
    func testSaveNewBoard() {
        let column = Column()
        column.name = "hello world"
        column.addCard(text:"lorem ipsum")
        column.addCard(text:"column b")
        guard
            let data = try? JSONEncoder().encode(column),
            let decoded = try? JSONDecoder().decode(Column.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual("hello world", column.name)
        XCTAssertEqual("lorem ipsum", decoded.cards[0].content)
        XCTAssertEqual("column b", decoded.cards[1].content)
    }
}
