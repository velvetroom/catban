import Foundation

struct Session_v1:SessionProtocol, Codable {
    var boards:[String]
    
    init() {
        self.boards = []
    }
}
