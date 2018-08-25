import Foundation
import CleanArchitecture

class LibraryView:View<LibraryPresenter> {
    weak var loading:LoadingView!
    weak var scroll:UIScrollView!
    weak var message:UILabel!
    weak var add:UIBarButtonItem!
    weak var scan:UIBarButtonItem!
    weak var settings:UIBarButtonItem!
    
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
        message.textColor = UIColor(white:0.0, alpha:0.7)
        message.numberOfLines = 0
        message.isUserInteractionEnabled = false
        self.message = message
        self.view.addSubview(message)
        
        let loading:LoadingView = LoadingView()
        loading.tintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        self.loading = loading
        self.view.addSubview(loading)
        
        let add:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.add,
                                                  target:self.presenter, action:#selector(self.presenter.newBoard))
        self.add = add
        let scan:UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "assetQr.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                                                   action:#selector(self.presenter.scan))
        self.scan = scan
        let settings:UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "assetEdit.pdf"), style:UIBarButtonItem.Style.plain,
                                                       target:self.presenter, action:#selector(self.presenter.settings))
        self.settings = settings
        self.navigationItem.rightBarButtonItems = [add, scan, settings]
    }
    
    private func layoutOutlets() {
        self.scroll.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.scroll.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        self.scroll.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        
        self.message.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant:Constants.margin).isActive = true
        self.message.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant:-Constants.margin).isActive = true
        
        self.loading.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        self.loading.centerYAnchor.constraint(equalTo:self.view.centerYAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
            self.scroll.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.message.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor,
                                              constant:Constants.margin).isActive = true
        } else {
            self.scroll.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
            self.message.topAnchor.constraint(equalTo:self.view.topAnchor, constant:Constants.margin).isActive = true
        }
    }
    
    private func configureViewModel() {
        self.presenter.viewModels.observe { [weak self] (viewModel:LibraryViewModel) in
            self?.loading.isHidden = viewModel.loadingHidden
            self?.add.isEnabled = viewModel.actionsEnabled
            self?.scan.isEnabled = viewModel.actionsEnabled
            self?.settings.isEnabled = viewModel.actionsEnabled
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
    static let margin:CGFloat = 17.0
    static let cellHeight:CGFloat = 60.0
}
