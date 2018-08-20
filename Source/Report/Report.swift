import Foundation

public class Report {
    let visitors:[ReportVisitor]
    
    public init() {
        self.visitors = [ReportColumns(), ReportProgress(), ReportCards(), ReportLongerColumn()]
    }
    
    public func makeStats(board:Board) -> ReportStats {
        let stats:ReportStats = ReportStats()
        self.visitors.forEach { (visitor:ReportVisitor) in
            visitor.visit(board:board, stats:stats)
        }
        return stats
    }
}
