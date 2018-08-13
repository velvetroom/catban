import Foundation

public protocol ReportProtocol {
    func makeStats(board:Board) -> ReportStats
}
