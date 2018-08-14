import Foundation

class ReportColumns:ReportVisitor {
    func visit(board:Board, stats:ReportStats) {
        board.columns.forEach { (column:Column) in
            stats.columns.append(column.cards.count)
        }
    }
}
