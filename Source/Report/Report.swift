import Foundation

class Report:ReportProtocol {
    func makeStats(board:Board) -> ReportStats {
        return ReportStats()
    }
}
