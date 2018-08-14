import Foundation

class Report:ReportProtocol {
    let visitors:[ReportVisitor]
    
    init() {
        self.visitors = [ReportColumns(), ReportProgress(), ReportCards(), ReportLongerColumn()]
    }
    
    func makeStats(board:Board) -> ReportStats {
        let stats:ReportStats = ReportStats()
        self.visitors.forEach { (visitor:ReportVisitor) in
            visitor.visit(board:board, stats:stats)
        }
        return stats
    }
}
