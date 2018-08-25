import Foundation

class ReportProgress:ReportVisitor {
    func visit(board:Board, stats:ReportStats) {
        var counter:Float = 0
        board.columns.forEach { (column) in
            counter += Float(column.cards.count)
        }
        if counter > 0 {
            if let lastColumn = board.columns.last {
                stats.progress = Float(lastColumn.cards.count) / counter
            }
        }
    }
}
