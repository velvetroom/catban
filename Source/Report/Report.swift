import Foundation

public class Report {
    let visitors:[ReportVisitor]
    
    public init() {
        visitors = [ReportColumns(), ReportProgress(), ReportCards(), ReportLongerColumn()]
    }
    
    public func makeStats(board:Board) -> ReportStats {
        let stats = ReportStats()
        visitors.forEach { (visitor) in
            visitor.visit(board:board, stats:stats)
        }
        return stats
    }
}
