import UIKit
import CleanArchitecture

class BoardView:View<BoardPresenter> {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeOutlets()
        self.layoutOutlets()
        self.view.backgroundColor = UIColor.white
        self.title = self.presenter.interactor.board.name
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.never
        }
    }
    
    private func makeOutlets() {
        
    }
    
    private func layoutOutlets() {
        
    }
}
