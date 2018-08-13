import Foundation

class ReportLongerColumn:ReportVisitor {
    func visit(board:Board, stats:ReportStats) {
        board.columns.forEach { (column:Column) in
            stats.longerColumn = max(stats.longerColumn, column.cards.count)
        }
    }
}
