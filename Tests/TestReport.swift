import XCTest
@testable import Catban

class TestReport:XCTestCase {
    private var report:Report!
    
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        report = Report()
    }

    func testStatsWithColumns() {
        let stats = report.makeStats(board:makeBoard())
        XCTAssertEqual(3, stats.columns.count)
        XCTAssertEqual(2, stats.columns.first)
        XCTAssertEqual(3, stats.columns.last)
    }
    
    func testStatsWithProgress() {
        XCTAssertEqual(0.6, report.makeStats(board:makeBoard()).progress)
    }
    
    func testStatsWithCards() {
        XCTAssertEqual(5, report.makeStats(board:makeBoard()).cards)
    }
    
    func testLongerColumn() {
        XCTAssertEqual(3, report.makeStats(board:makeBoard()).longerColumn)
    }
    
    private func makeBoard() -> Board {
        let board = Board()
        board.addColumn(text:"First")
        board.addColumn(text:"Second")
        board.addColumn(text:"Third")
        board.columns[0].addCard(text:"First card")
        board.columns[0].addCard(text:"Second card")
        board.columns[2].addCard(text:"Third card")
        board.columns[2].addCard(text:"Fourth card")
        board.columns[2].addCard(text:"Fifth card")
        return board
    }
}
