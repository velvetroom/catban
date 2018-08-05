import UIKit
import CleanArchitecture

class BoardView:View<BoardPresenter> {
    weak var scroll:UIScrollView!
    weak var canvas:Canvas!
    
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        self.configureViewModel()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = self.presenter.interactor.board.name
    }
    
    private func clearCanvas() {
        self.canvas.subviews.forEach { (view:UIView) in view.removeFromSuperview() }
    }
    
    private func makeOutlets() {
        let scroll:UIScrollView = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.clipsToBounds = true
        scroll.backgroundColor = UIColor.clear
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = true
        scroll.decelerationRate = UIScrollView.DecelerationRate.fast
        scroll.canCancelContentTouches = false
        self.scroll = scroll
        self.view.addSubview(scroll)
        
        let canvas:Canvas = Canvas()
        self.canvas = canvas
        self.scroll.addSubview(canvas)
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetDelete.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.delete)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetShare.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.share)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetRename.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.name))]
    }
    
    private func layoutOutlets() {
        self.scroll.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.scroll.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
            self.scroll.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.scroll.bottomAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            self.scroll.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
            self.scroll.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        }
    }
    
    private func configureViewModel() {
        self.presenter.viewModels.observe { [weak self] (viewModel:BoardViewModel) in
            self?.title = viewModel.title
        }
    }
}
