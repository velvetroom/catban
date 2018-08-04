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
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
        }
    }
    
    private func makeOutlets() {
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetDelete.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.delete)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetShare.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.share)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetRename.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.share))]
    }
    
    private func layoutOutlets() {
        
    }
}
