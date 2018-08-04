import UIKit
import CleanArchitecture

class BoardView:View<BoardPresenter> {
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        self.configureViewModel()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = self.presenter.interactor.board.name
    }
    
    private func makeOutlets() {
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetDelete.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.delete)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetShare.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.share)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetRename.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.name))]
    }
    
    private func layoutOutlets() {
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
        }
    }
    
    private func configureViewModel() {
        self.presenter.viewModels.observe { [weak self] (viewModel:BoardViewModel) in
            self?.title = viewModel.title
        }
    }
}
