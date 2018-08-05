import UIKit
import CleanArchitecture

class LibraryView:View<LibraryPresenter> {
    weak var loading:LoadingView!
    weak var scroll:UIScrollView!
    weak var message:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("LibraryView.title", comment:String())
        self.view.backgroundColor = UIColor.white
        self.makeOutlets()
        self.layoutOutlets()
        self.configureViewModel()
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        self.layoutCells(size:size)
    }
    
    private func makeOutlets() {
        let scroll:UIScrollView = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        self.scroll = scroll
        self.view.addSubview(scroll)
        
        let message:UILabel = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.light)
        message.textColor = UIColor(white:0.0, alpha:0.8)
        message.numberOfLines = 0
        message.isUserInteractionEnabled = false
        self.message = message
        self.view.addSubview(message)
        
        let loading:LoadingView = LoadingView()
        loading.tintColor = Colors.navyBlue
        self.loading = loading
        self.view.addSubview(loading)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem:UIBarButtonItem.SystemItem.add, target:self.presenter,
            action:#selector(self.presenter.newBoard))
    }
    
    private func layoutOutlets() {
        self.scroll.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.scroll.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        
        self.message.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant:Constants.margin).isActive = true
        self.message.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant:-Constants.margin).isActive = true
        self.message.heightAnchor.constraint(greaterThanOrEqualToConstant:0)
        
        self.loading.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        self.loading.centerYAnchor.constraint(equalTo:self.view.centerYAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
            self.scroll.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.scroll.bottomAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            self.message.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor,
                                              constant:Constants.margin).isActive = true
        } else {
            self.scroll.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
            self.scroll.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
            self.message.topAnchor.constraint(equalTo:self.view.topAnchor, constant:Constants.margin).isActive = true
        }
    }
    
    private func configureViewModel() {
        self.presenter.viewModels.observe { [weak self] (viewModel:LibraryViewModel) in
            self?.loading.isHidden = viewModel.loadingHidden
            self?.navigationItem.rightBarButtonItem?.isEnabled = viewModel.addEnabled
            self?.message.text = viewModel.message
            self?.update(items:viewModel.items)
        }
    }
    
    private func update(items:[LibraryItemViewModel]) {
        self.scroll.subviews.forEach { (view:UIView) in view.removeFromSuperview() }
        items.forEach { (item:LibraryItemViewModel) in
            let cell:LibraryCellView = LibraryCellView()
            cell.viewModel = item
            cell.addTarget(self.presenter, action:#selector(self.presenter.selected(cell:)),
                           for:UIControl.Event.touchUpInside)
            cell.addTarget(self.presenter, action:#selector(self.presenter.highlight(cell:)),
                           for:UIControl.Event(arrayLiteral:UIControl.Event.touchDown,
                                               UIControl.Event.touchDragEnter))
            cell.addTarget(self.presenter, action:#selector(self.presenter.unhighlight(cell:)),
                           for:UIControl.Event(arrayLiteral:UIControl.Event.touchUpOutside,
                                               UIControl.Event.touchDragExit, UIControl.Event.touchCancel))
            self.scroll.addSubview(cell)
        }
        self.layoutCells(size:self.view.bounds.size)
    }
    
    private func layoutCells(size:CGSize) {
        var y:CGFloat = 0
        self.scroll.subviews.forEach { (view:UIView) in
            view.frame = CGRect(x:0, y:y, width:size.width, height:Constants.cellHeight)
            y += Constants.cellHeight
        }
        self.scroll.contentSize = CGSize(width:size.width, height:y)
    }
}

private struct Constants {
    static let font:CGFloat = 16.0
    static let margin:CGFloat = 20.0
    static let cellHeight:CGFloat = 52.0
}
