import Foundation

class ReportProgress:ReportVisitor {
    func visit(board:Board, stats:ReportStats) {
        var counter:Float = 0.0
        board.columns.forEach { (column:Column) in
            counter += Float(column.cards.count)
        }
        if counter > 0.0 {
            if let lastColumn:Column = board.columns.last {
                stats.progress = Float(lastColumn.cards.count) / counter
            }
        }
    }
}
