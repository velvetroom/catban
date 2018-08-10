import Foundation

public struct Session:Codable {
    public var boards:[String]
    
    init() {
        self.boards = []
    }
}
