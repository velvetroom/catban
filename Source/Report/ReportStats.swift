import Foundation

public class ReportStats {
    public internal(set) var columns:[Int]
    public internal(set) var progress:Float
    public internal(set) var cards:Int
    public internal(set) var longerColumn:Int
    
    init() {
        columns = []
        progress = 0
        cards = 0
        longerColumn = 0
    }
}
