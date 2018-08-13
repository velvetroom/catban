import Foundation

protocol ReportVisitor {
    func visit(board:Board, stats:ReportStats)
}
