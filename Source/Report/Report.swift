import Foundation

public class Report {
    private var visitors:[(Board, ReportStats) -> Void]!
    
    public init() {
        visitors = [columns, progress, cards, longerColumn]
    }
    
    public func makeStats(board:Board) -> ReportStats {
        return visitors.reduce(into:ReportStats()) { stats, visitor in visitor(board, stats) }
    }
    
    private func columns(board:Board, stats:ReportStats) {
        board.columns.forEach { column in
            stats.columns.append(column.cards.count)
        }
    }
    
    private func progress(board:Board, stats:ReportStats) {
        var counter:Float = 0
        board.columns.forEach { column in
            counter += Float(column.cards.count)
        }
        if counter > 0,
           let lastColumn = board.columns.last {
            stats.progress = Float(lastColumn.cards.count) / counter
        }
    }
    
    private func cards(board:Board, stats:ReportStats) {
        board.columns.forEach { column in
            stats.cards += column.cards.count
        }
    }
    
    private func longerColumn(board:Board, stats:ReportStats) {
        board.columns.forEach { column in
            stats.longerColumn = max(stats.longerColumn, column.cards.count)
        }
    }
}
