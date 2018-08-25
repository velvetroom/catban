import Foundation

class ReportLongerColumn:ReportVisitor {
    func visit(board:Board, stats:ReportStats) {
        board.columns.forEach { (column) in
            stats.longerColumn = max(stats.longerColumn, column.cards.count)
        }
    }
}
