import Foundation

class Board_v1:BoardProtocol, Codable {
    var text:String
    var created:Date
    var syncstamp:Date
    var columns:[Column]
    
    init() {
        self.text = String()
        self.created = Date()
        self.syncstamp = Date()
        self.columns = []
    }
}
