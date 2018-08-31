import Foundation

class LibraryQuickBoard:LibraryState {
    private let board:String
    
    init(board:String) {
        self.board = board
    }
    
    func boardsUpdated(context:LibraryInteractor) {
        context.state = LibraryDefault()
        context.select(identifier:board)
    }
}