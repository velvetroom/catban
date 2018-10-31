import CleanArchitecture

class LibraryView:View<LibraryPresenter>, UIViewControllerPreviewingDelegate {
    private weak var loading:LoadingView!
    private weak var scroll:UIScrollView!
    private weak var content:UIView!
    private weak var message:UILabel!
    private weak var load:UIButton!
    private weak var add:UIBarButtonItem!
    private weak var scan:UIBarButtonItem!
    private weak var settings:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = .local("LibraryView.title")
        view.backgroundColor = Application.interface.background
        makeOutlets()
        configureViewModel()
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        layoutCells(size:size)
    }
    
    func previewingContext(_ context:UIViewControllerPreviewing,
                           viewControllerForLocation location:CGPoint) -> UIViewController? {
        var view:UIViewController?
        if let item = content.subviews.first(where: { $0.frame.contains(location) } ) as? LibraryCellView {
            context.sourceRect = item.frame
            view = presenter.board(identifier:item.viewModel.board)
        }
        return view
    }
    
    func previewingContext(_:UIViewControllerPreviewing, commit controller:UIViewController) {
        Application.navigation.pushViewController(controller, animated:true)
    }
    
    private func makeOutlets() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.indicatorStyle = Application.interface.scroll
        view.addSubview(scroll)
        self.scroll = scroll
        
        let content = UIView()
        scroll.addSubview(content)
        registerForPreviewing(with:self, sourceView:content)
        self.content = content
        
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = .systemFont(ofSize:16, weight:.light)
        message.textColor = Application.interface.text.withAlphaComponent(0.7)
        message.numberOfLines = 0
        message.isUserInteractionEnabled = false
        view.addSubview(message)
        self.message = message
        
        let load = UIButton()
        load.translatesAutoresizingMaskIntoConstraints = false
        load.setTitle(.local("LibraryView.load"), for:[])
        load.setTitleColor(Application.interface.text, for:.normal)
        load.setTitleColor(Application.interface.text.withAlphaComponent(0.2), for:.highlighted)
        load.titleLabel!.font = .systemFont(ofSize:20, weight:.bold)
        load.addTarget(presenter, action:#selector(presenter.manuallyLoadCloud), for:.touchUpInside)
        load.isHidden = true
        self.load = load
        view.addSubview(load)
        
        let loading = LoadingView()
        view.addSubview(loading)
        self.loading = loading
        
        let add = UIBarButtonItem(barButtonSystemItem:.add, target:presenter, action:#selector(presenter.newBoard))
        let scan = UIBarButtonItem(image:#imageLiteral(resourceName: "assetQr.pdf"), style:.plain, target:presenter, action:#selector(presenter.scan))
        let settings = UIBarButtonItem(image:#imageLiteral(resourceName: "assetEdit.pdf"), style:.plain, target:presenter, action:#selector(presenter.settings))
        navigationItem.rightBarButtonItems = [add, scan, settings]
        self.add = add
        self.scan = scan
        self.settings = settings
        
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        scroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        
        message.leftAnchor.constraint(equalTo:view.leftAnchor, constant:17).isActive = true
        message.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-17).isActive = true
        message.topAnchor.constraint(equalTo:view.topAnchor, constant:17).isActive = true
        
        load.topAnchor.constraint(equalTo:message.bottomAnchor, constant:20).isActive = true
        load.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        load.widthAnchor.constraint(equalToConstant:120).isActive = true
        load.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        loading.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (viewModel:LibraryItems) in
            self?.loading.isHidden = viewModel.loadingHidden
            self?.add.isEnabled = viewModel.actionsEnabled
            self?.scan.isEnabled = viewModel.actionsEnabled
            self?.settings.isEnabled = viewModel.actionsEnabled
            self?.message.attributedText = viewModel.message
            self?.load.isHidden = viewModel.loadHidden
            self?.update(items:viewModel.items)
        }
    }
    
    private func update(items:[LibraryItem]) {
        var top = content.topAnchor
        content.subviews.forEach { $0.removeFromSuperview() }
        items.forEach { item in
            let cell = LibraryCellView()
            cell.viewModel = item
            cell.addTarget(presenter, action:#selector(presenter.selected(cell:)), for:.touchUpInside)
            cell.addTarget(presenter, action:#selector(presenter.highlight(cell:)), for:[.touchDown, .touchDragEnter])
            cell.addTarget(presenter, action:#selector(presenter.unhighlight(cell:)), for:
                [.touchUpOutside, .touchDragExit, .touchCancel])
            content.addSubview(cell)
            
            cell.topAnchor.constraint(equalTo:top, constant:20).isActive = true
            cell.leftAnchor.constraint(equalTo:content.leftAnchor, constant:20).isActive = true
            cell.rightAnchor.constraint(equalTo:content.rightAnchor, constant:20).isActive = true
            top = cell.bottomAnchor
        }
        layoutCells(size:view.bounds.size)
    }
    
    private func layoutCells(size:CGSize) {
        scroll.contentSize = CGSize(width:size.width, height:30 + (CGFloat(content.subviews.count) * 68))
        content.frame = CGRect(origin:CGPoint.zero, size:scroll.contentSize)
    }
}
