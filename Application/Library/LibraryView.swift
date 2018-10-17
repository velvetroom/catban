import CleanArchitecture

class LibraryView:View<LibraryPresenter>, UIViewControllerPreviewingDelegate {
    private weak var loading:LoadingView!
    private weak var scroll:UIScrollView!
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
        if let item = scroll.subviews.first(where: { item in item.frame.contains(location) } ) {
            context.sourceRect = item.frame
            view = presenter.board(identifier:(item as! LibraryCellView).viewModel.board)
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
        registerForPreviewing(with:self, sourceView:scroll)
        self.scroll = scroll
        
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
        load.titleLabel!.font = .systemFont(ofSize:16, weight:.bold)
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
        
        message.leftAnchor.constraint(equalTo:view.leftAnchor, constant:17).isActive = true
        message.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-17).isActive = true
        
        load.topAnchor.constraint(equalTo:message.bottomAnchor).isActive = true
        load.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        load.widthAnchor.constraint(equalToConstant:65).isActive = true
        load.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        loading.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            scroll.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            message.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:17).isActive = true
        } else {
            scroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            message.topAnchor.constraint(equalTo:view.topAnchor, constant:17).isActive = true
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
        scroll.subviews.forEach { view in view.removeFromSuperview() }
        items.forEach { item in
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
        scroll.contentSize = CGSize(width:size.width, height:scroll.subviews.reduce(into:0) { y, view in
            y += 20
            view.frame = CGRect(x:14, y:y, width:size.width, height:48)
            y += view.bounds.height
        } + 30)
    }
}
