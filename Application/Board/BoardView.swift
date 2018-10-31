import CleanArchitecture

class BoardView:View<BoardPresenter>, UISearchResultsUpdating, UISearchBarDelegate {
    let drawer = BoardDrawer()
    let layouter = BoardLayouter()
    private(set) weak var scroll:UIScrollView!
    private(set) weak var content:UIView!
    private weak var report:UIView!
    private weak var percent:UILabel!
    private weak var progress:UIProgressView!
    private weak var stack:BoardStackView!
    private weak var layoutReportTop:NSLayoutConstraint!
    private var reportY:CGFloat = 0
    private var reportHandler:(() -> Void)!
    
    @objc func long(gesture:UILongPressGestureRecognizer) {
        let view = gesture.view as! BoardCardView
        switch gesture.state {
        case .began:
            gesture.isEnabled = false
            detach(card:view)
            view.top.constant = 0
            view.left.constant += 270
            attach(card:view)
        case .cancelled, .ended, .failed:
            gesture.isEnabled = true
        case .possible, .changed: break
        }
    }
    
    @objc func dragCard(pan:UIPanGestureRecognizer) {
        let view = pan.view as! BoardCardView
        switch pan.state {
        case .began:
            view.dragStart()
            detach(card:view)
        case .cancelled, .ended, .failed:
            view.dragEnd()
            attach(card:view)
        case .possible, .changed: view.drag(point:pan.translation(in:content))
        }
    }
    
    @objc func dragReport(pan:UIPanGestureRecognizer) {
        switch pan.state {
        case .began: reportY = layoutReportTop.constant
        case .possible, .changed:
            layoutReportTop.constant = reportY + pan.translation(in:view).y
            if layoutReportTop.constant < -290 {
                layoutReportTop.constant = -290
            }
        case .cancelled, .ended, .failed:
            reportHandler()
        }
    }
    
    override func viewDidLoad() {
        drawer.view = self
        layouter.view = self
        makeOutlets()
        configureViewModel()
        super.viewDidLoad()
        view.backgroundColor = Application.interface.background
        title = presenter.board.name
        reportHandler = handlerHidden
    }
    
    override var previewActionItems:[UIPreviewActionItem] { return [
        UIPreviewAction(title:.local("BoardView.share"), style:.default)
        { [weak self] _, _ in self?.presenter.share() },
        UIPreviewAction(title:.local("BoardView.delete"), style:.destructive)
        { [weak self] _, _ in self?.presenter.delete() }]
    }
    
    func updateSearchResults(for search:UISearchController) {
        guard
            let text = search.searchBar.text,
            !text.isEmpty
        else {
            presenter.clearSearch()
            return
        }
        presenter.search(text:text)
    }
    
    func searchBarCancelButtonClicked(_ bar:UISearchBar) {
        bar.setShowsCancelButton(false, animated:true)
        presenter.clearSearch()
    }
    
    private func makeOutlets() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.indicatorStyle = Application.interface.scroll
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = true
        scroll.decelerationRate = .fast
        view.addSubview(scroll)
        self.scroll = scroll
        
        let report = UIView()
        report.translatesAutoresizingMaskIntoConstraints = false
        report.backgroundColor = Application.interface.over
        report.layer.cornerRadius = 30
        report.addGestureRecognizer(UIPanGestureRecognizer(target:self, action:#selector(dragReport(pan:))))
        view.addSubview(report)
        self.report = report
        
        let handle = UIView()
        handle.isUserInteractionEnabled = false
        handle.translatesAutoresizingMaskIntoConstraints = false
        handle.clipsToBounds = true
        handle.backgroundColor = Application.interface.tint.withAlphaComponent(0.15)
        handle.layer.cornerRadius = 1.5
        report.addSubview(handle)
        
        let track = UIView()
        track.isUserInteractionEnabled = false
        track.translatesAutoresizingMaskIntoConstraints = false
        track.backgroundColor = Application.interface.tint.withAlphaComponent(0.1)
        report.addSubview(track)
        
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isUserInteractionEnabled = false
        progress.progressTintColor = .catBlue
        progress.layer.cornerRadius = 3
        progress.clipsToBounds = true
        progress.trackImage = UIImage()
        report.addSubview(progress)
        self.progress = progress
        
        let stack = BoardStackView()
        report.addSubview(stack)
        self.stack = stack
        
        let content = UIView()
        content.clipsToBounds = false
        scroll.addSubview(content)
        self.content = content
        
        let percent = UILabel()
        percent.translatesAutoresizingMaskIntoConstraints = false
        percent.textAlignment = .center
        percent.isUserInteractionEnabled = false
        percent.font = .systemFont(ofSize:30, weight:.bold)
        percent.textColor = Application.interface.text
        report.addSubview(percent)
        self.percent = percent
        
        let sign = UILabel()
        sign.translatesAutoresizingMaskIntoConstraints = false
        sign.isUserInteractionEnabled = false
        sign.font = .systemFont(ofSize:14, weight:.ultraLight)
        sign.textColor = Application.interface.text
        sign.text = "%"
        report.addSubview(sign)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetEdit.pdf"), style:.plain, target:presenter, action:#selector(presenter.edit)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetShare.pdf"), style:.plain, target:presenter, action:#selector(presenter.share)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetInfo.pdf"), style:.plain, target:presenter, action:#selector(presenter.info))]
        
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        scroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        
        report.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        report.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        report.heightAnchor.constraint(equalToConstant:350).isActive = true
        layoutReportTop = report.topAnchor.constraint(equalTo:view.bottomAnchor, constant:-55)
        layoutReportTop.isActive = true
        
        handle.topAnchor.constraint(equalTo:report.topAnchor, constant:12).isActive = true
        handle.centerXAnchor.constraint(equalTo:report.centerXAnchor).isActive = true
        handle.widthAnchor.constraint(equalToConstant:30).isActive = true
        handle.heightAnchor.constraint(equalToConstant:3).isActive = true
        
        track.heightAnchor.constraint(equalToConstant:2).isActive = true
        track.leftAnchor.constraint(equalTo:progress.leftAnchor).isActive = true
        track.rightAnchor.constraint(equalTo:progress.rightAnchor).isActive = true
        track.centerYAnchor.constraint(equalTo:progress.centerYAnchor).isActive = true
        
        progress.widthAnchor.constraint(equalToConstant:250).isActive = true
        progress.heightAnchor.constraint(equalToConstant:3).isActive = true
        progress.centerXAnchor.constraint(equalTo:report.centerXAnchor).isActive = true
        progress.topAnchor.constraint(equalTo:handle.bottomAnchor, constant:20).isActive = true
        
        stack.centerXAnchor.constraint(equalTo:report.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo:progress.bottomAnchor, constant:45).isActive = true
        
        percent.centerXAnchor.constraint(equalTo:stack.centerXAnchor).isActive = true
        percent.centerYAnchor.constraint(equalTo:stack.centerYAnchor).isActive = true
        
        sign.leftAnchor.constraint(equalTo:percent.rightAnchor).isActive = true
        sign.centerYAnchor.constraint(equalTo:percent.centerYAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController:nil)
            search.searchResultsUpdater = self
            search.isActive = true
            search.obscuresBackgroundDuringPresentation = false
            search.hidesNavigationBarDuringPresentation = false
            search.searchBar.delegate = self
            search.searchBar.barStyle = Application.interface.bar
            search.searchBar.tintColor = Application.interface.tint
            search.searchBar.autocorrectionType = .yes
            search.searchBar.spellCheckingType = .yes
            search.searchBar.autocapitalizationType = .sentences
            search.searchBar.keyboardType = .asciiCapable
            search.searchBar.keyboardAppearance = Application.interface.keyboard
            
            navigationItem.searchController = search
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (title:String) in
            self?.title = title
            self?.drawer.draw()
            self?.layouter.layout()
        }
        presenter.viewModel { [weak self] (viewModel:Float) in
            self?.progress.setProgress(viewModel, animated:true)
            self?.percent.text = String(Int((viewModel) * 100))
        }
        presenter.viewModel { [weak self] (viewModel:[(CGFloat, CGFloat)]) in
            self?.stack.viewModel = viewModel
        }
    }
    
    private func animate() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.content?.layoutIfNeeded()
        }
    }
    
    private func handlerHidden() {
        if layoutReportTop.constant < -85 {
            showReport()
        } else {
            hideReport()
        }
    }
    
    private func handlerShown() {
        if layoutReportTop.constant < -260 {
            showReport()
        } else {
            hideReport()
        }
    }
    
    private func hideReport() {
        reportHandler = handlerHidden
        layoutReportTop.constant = -55
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func showReport() {
        reportHandler = handlerShown
        layoutReportTop.constant = -290
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func detach(card:BoardCardView) {
        content.bringSubviewToFront(card)
        layouter.detach(item:card)
        animate()
    }
    
    private func attach(card:BoardCardView) {
        layouter.attach(item:card)
        animate()
        presenter.updateProgress()
    }
}
