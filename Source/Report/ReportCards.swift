import Foundation

class ReportCards:ReportVisitor {
    func visit(board:Board, stats:ReportStats) {
        board.columns.forEach { (column:Column) in
            stats.cards += column.cards.count
        }
    }
}
