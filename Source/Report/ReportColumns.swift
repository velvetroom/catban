import Foundation

class ReportColumns:ReportVisitor {
    func visit(board:Board, stats:ReportStats) {
        board.columns.forEach { (column) in
            stats.columns.append(column.cards.count)
        }
    }
}
