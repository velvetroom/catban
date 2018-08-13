import Foundation

public class ReportStats {
    public internal(set) var columns:[Int]
    public internal(set) var progress:Float
    public internal(set) var cards:Int
    public internal(set) var longerColumn:Int
    
    init() {
        self.columns = []
        self.progress = 0.0
        self.cards = 0
        self.longerColumn = 0
    }
}
