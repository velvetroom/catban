import XCTest
@testable import Catban

class TestReport:XCTestCase {
    private var report:Report!
    
    override func setUp() {
        super.setUp()
        self.report = Report()
    }

    func testStatsWithColumns() {
        let stats:ReportStats = self.report.makeStats(board:self.makeBoard())
        XCTAssertEqual(stats.columns.count, 3, "Should have 3 columns")
        XCTAssertEqual(2, stats.columns.first, "First column should have 2 cards")
        XCTAssertEqual(3, stats.columns.last, "Last column should have 3 cards")
    }
    
    func testStatsWithProgress() {
        let stats:ReportStats = self.report.makeStats(board:self.makeBoard())
        XCTAssertEqual(stats.progress, 0.6, "Should have 60% progress")
    }
    
    func testStatsWithCards() {
        let stats:ReportStats = self.report.makeStats(board:self.makeBoard())
        XCTAssertEqual(stats.cards, 5, "Should have 5 cards")
    }
    
    func testLongerColumn() {
        let stats:ReportStats = self.report.makeStats(board:self.makeBoard())
        XCTAssertEqual(stats.longerColumn, 3, "Longer column should have 3 cards")
    }
    
    private func makeBoard() -> Board {
        let board:Board = Board()
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
