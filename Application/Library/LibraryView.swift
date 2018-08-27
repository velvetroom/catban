import Foundation
import CleanArchitecture

class LibraryView:View<LibraryPresenter> {
    weak var loading:LoadingView!
    weak var scroll:UIScrollView!
    weak var message:UILabel!
    weak var add:UIBarButtonItem!
    weak var scan:UIBarButtonItem!
    weak var settings:UIBarButtonItem!
    private static let margin:CGFloat = 17
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("LibraryView.title", comment:String())
        view.backgroundColor = .white
        makeOutlets()
        layoutOutlets()
        configureViewModel()
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        layoutCells(size:size)
    }
    
    private func makeOutlets() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)
        self.scroll = scroll
        
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = UIFont.systemFont(ofSize:16, weight:.light)
        message.textColor = UIColor(white:0, alpha:0.7)
        message.numberOfLines = 0
        message.isUserInteractionEnabled = false
        view.addSubview(message)
        self.message = message
        
        let loading = LoadingView()
        loading.tintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        view.addSubview(loading)
        self.loading = loading
        
        let add = UIBarButtonItem(barButtonSystemItem:.add, target:presenter, action:#selector(presenter.newBoard))
        let scan = UIBarButtonItem(image:#imageLiteral(resourceName: "assetQr.pdf"), style:.plain, target:presenter, action:#selector(presenter.scan))
        let settings = UIBarButtonItem(image:#imageLiteral(resourceName: "assetEdit.pdf"), style:.plain, target:presenter, action:#selector(presenter.settings))
        navigationItem.rightBarButtonItems = [add, scan, settings]
        self.add = add
        self.scan = scan
        self.settings = settings
    }
    
    private func layoutOutlets() {
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        message.leftAnchor.constraint(equalTo:view.leftAnchor, constant:LibraryView.margin).isActive = true
        message.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-LibraryView.margin).isActive = true
        
        loading.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            scroll.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            message.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor,
                                         constant:LibraryView.margin).isActive = true
        } else {
            scroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            message.topAnchor.constraint(equalTo:view.topAnchor, constant:LibraryView.margin).isActive = true
        }
    }
    
    private func configureViewModel() {
        presenter.viewModels.observe { [weak self] (viewModel:LibraryItems) in
            self?.loading.isHidden = viewModel.loadingHidden
            self?.add.isEnabled = viewModel.actionsEnabled
            self?.scan.isEnabled = viewModel.actionsEnabled
            self?.settings.isEnabled = viewModel.actionsEnabled
            self?.message.text = viewModel.message
            self?.update(items:viewModel.items)
        }
    }
    
    private func update(items:[LibraryItem]) {
        scroll.subviews.forEach { (view) in view.removeFromSuperview() }
        items.forEach { (item) in
            let cell = LibraryCellView()
            cell.viewModel = item
            cell.addTarget(presenter, action:#selector(presenter.selected(cell:)), for:.touchUpInside)
            cell.addTarget(presenter, action:#selector(presenter.highlight(cell:)), for:[.touchDown, .touchDragEnter])
            cell.addTarget(presenter, action:#selector(presenter.unhighlight(cell:)), for:
                [.touchUpOutside, .touchDragExit, .touchCancel])
            scroll.addSubview(cell)
        }
        layoutCells(size:view.bounds.size)
    }
    
    private func layoutCells(size:CGSize) {
        var y:CGFloat = 0
        scroll.subviews.forEach { (view) in
            view.frame = CGRect(x:0, y:y, width:size.width, height:70)
            y += view.bounds.height
        }
        scroll.contentSize = CGSize(width:size.width, height:y)
    }
}
