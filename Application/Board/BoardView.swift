import UIKit
import CleanArchitecture

class BoardView:View<BoardPresenter>, UISearchResultsUpdating, UISearchBarDelegate {
    weak var scroll:UIScrollView!
    weak var content:UIView!
    weak var report:UIView!
    weak var border:UIView!
    weak var handle:UIView!
    weak var progress:UIProgressView!
    weak var stack:BoardStackView!
    weak var layoutReportTop:NSLayoutConstraint!
    let drawer = BoardDrawer()
    let layouter = BoardLayouter()
    private var reportY:CGFloat = 0
    private var reportHandler:(() -> Void)!
    
    @objc func dragCard(pan:UIPanGestureRecognizer) {
        let view = pan.view as! BoardCardView
        switch pan.state {
        case .began:
            view.dragStart()
            content.bringSubviewToFront(view)
            layouter.detach(item:view)
            animate()
        case .cancelled, .ended, .failed:
            view.dragEnd()
            layouter.attach(item:view)
            animate()
            presenter.updateProgress()
        case .possible, .changed: view.drag(point:pan.translation(in:content))
        }
    }
    
    @objc func dragReport(pan:UIPanGestureRecognizer) {
        switch pan.state {
        case .began: reportY = layoutReportTop.constant
        case .possible, .changed:
            layoutReportTop.constant = reportY + pan.translation(in:view).y
            if layoutReportTop.constant < -390 {
                layoutReportTop.constant = -390
            }
        case .cancelled, .ended, .failed:
            reportHandler()
        }
    }
    
    override func viewDidLoad() {
        drawer.view = self
        layouter.view = self
        makeOutlets()
        layoutOutlets()
        configureViewModel()
        super.viewDidLoad()
        view.backgroundColor = .white
        title = presenter.interactor.board.text
        reportHandler = handlerHidden
    }
    
    override var previewActionItems:[UIPreviewActionItem] { return [
        UIPreviewAction(title:NSLocalizedString("BoardView.share", comment:String()), style:.default)
        { [weak self] (_, _) in self?.presenter.share() },
        UIPreviewAction(title:NSLocalizedString("BoardView.delete", comment:String()), style:.destructive)
        { [weak self] (_, _) in self?.presenter.delete() }]
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
        scroll.clipsToBounds = true
        scroll.backgroundColor = .clear
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = true
        scroll.decelerationRate = .fast
        view.addSubview(scroll)
        self.scroll = scroll
        
        let border = UIView()
        border.isUserInteractionEnabled = false
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor(white:0, alpha:0.03)
        view.addSubview(border)
        self.border = border
        
        let report = UIView()
        report.translatesAutoresizingMaskIntoConstraints = false
        report.backgroundColor = .white
        report.clipsToBounds = true
        report.addGestureRecognizer(UIPanGestureRecognizer(target:self, action:#selector(dragReport(pan:))))
        view.addSubview(report)
        self.report = report
        
        let handle = UIView()
        handle.isUserInteractionEnabled = false
        handle.translatesAutoresizingMaskIntoConstraints = false
        handle.clipsToBounds = true
        handle.backgroundColor = UIColor(white:0.9, alpha:1)
        handle.layer.cornerRadius = 1.5
        report.addSubview(handle)
        self.handle = handle
        
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isUserInteractionEnabled = false
        progress.progressTintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        progress.trackTintColor = UIColor(white:0.95, alpha:1)
        report.addSubview(progress)
        self.progress = progress
        
        let stack = BoardStackView()
        report.addSubview(stack)
        self.stack = stack
        
        let content = UIView()
        content.clipsToBounds = false
        scroll.addSubview(content)
        self.content = content
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetEdit.pdf"), style:.plain, target:presenter, action:#selector(presenter.edit)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetShare.pdf"), style:.plain, target:presenter, action:#selector(presenter.share)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetInfo.pdf"), style:.plain, target:presenter, action:#selector(presenter.info))]
    }
    
    private func layoutOutlets() {
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        report.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        report.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        report.heightAnchor.constraint(equalToConstant:390).isActive = true
        layoutReportTop = report.topAnchor.constraint(equalTo:view.bottomAnchor, constant:-75)
        layoutReportTop.isActive = true

        handle.topAnchor.constraint(equalTo:report.topAnchor, constant:14).isActive = true
        handle.centerXAnchor.constraint(equalTo:report.centerXAnchor).isActive = true
        handle.widthAnchor.constraint(equalToConstant:30).isActive = true
        handle.heightAnchor.constraint(equalToConstant:3).isActive = true
        
        border.bottomAnchor.constraint(equalTo:report.topAnchor).isActive = true
        border.leftAnchor.constraint(equalTo:report.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo:report.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant:3).isActive = true
        
        progress.widthAnchor.constraint(equalToConstant:250).isActive = true
        progress.heightAnchor.constraint(equalToConstant:4).isActive = true
        progress.centerXAnchor.constraint(equalTo:report.centerXAnchor).isActive = true
        progress.topAnchor.constraint(equalTo:handle.bottomAnchor, constant:25).isActive = true
        
        stack.centerXAnchor.constraint(equalTo:report.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo:progress.bottomAnchor, constant:35).isActive = true
        
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController:nil)
            search.searchResultsUpdater = self
            search.isActive = true
            search.obscuresBackgroundDuringPresentation = false
            search.hidesNavigationBarDuringPresentation = false
            search.searchBar.delegate = self
            navigationItem.searchController = search
            navigationItem.largeTitleDisplayMode = .always
            scroll.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            scroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func configureViewModel() {
        presenter.viewModels.observe { [weak self] (viewModel:BoardTitle) in
            self?.title = viewModel.title
            self?.drawer.draw()
            self?.layouter.layout()
        }
        presenter.viewModels.observe { [weak self] (viewModel:BoardProgress) in
            self?.progress.setProgress(viewModel.progress, animated:true)
            self?.stack.update(progress:viewModel)
        }
    }
    
    private func animate() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.content?.layoutIfNeeded()
        }
    }
    
    private func handlerHidden() {
        if layoutReportTop.constant < -105 {
            showReport()
        } else {
            hideReport()
        }
    }
    
    private func handlerShown() {
        if layoutReportTop.constant < -360 {
            showReport()
        } else {
            hideReport()
        }
    }
    
    private func hideReport() {
        reportHandler = handlerHidden
        layoutReportTop.constant = -75
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func showReport() {
        reportHandler = handlerShown
        layoutReportTop.constant = -390
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
