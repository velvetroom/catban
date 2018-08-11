import Foundation

public class Session:Codable {
    public private(set) var boards:[String]
    
    init() {
        self.boards = []
    }
    
    func add(board:String) {
        if !self.boards.contains(board) {
            self.boards.append(board)
        }
    }
    
    func remove(board:String) {
        self.boards.removeAll { (item:String) -> Bool in
            return item == board
        }
    }
}
