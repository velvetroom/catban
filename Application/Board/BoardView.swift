import UIKit
import CleanArchitecture

class BoardView:View<BoardPresenter> {
    weak var scroll:UIScrollView!
    weak var content:UIView!
    weak var report:UIView!
    weak var border:UIView!
    weak var handle:UIView!
    weak var progress:UIProgressView!
    weak var layoutReportTop:NSLayoutConstraint!
    let drawer:BoardDrawer
    let layouter:BoardLayouter
    private var reportY:CGFloat
    
    required init() {
        self.reportY = 0
        self.drawer = BoardDrawer()
        self.layouter = BoardLayouter()
        super.init()
        self.drawer.view = self
        self.layouter.view = self
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc func dragCard(pan:UIPanGestureRecognizer) {
        let view:BoardCardView = pan.view as! BoardCardView
        switch pan.state {
        case UIGestureRecognizer.State.began:
            view.dragStart()
            self.content.bringSubviewToFront(view)
            self.layouter.detach(item:view)
            self.animate()
        case UIGestureRecognizer.State.possible, UIGestureRecognizer.State.changed:
            view.drag(point:pan.translation(in:self.content))
        case UIGestureRecognizer.State.cancelled, UIGestureRecognizer.State.ended, UIGestureRecognizer.State.failed:
            view.dragEnd()
            self.layouter.attach(item:view)
            self.animate()
            self.presenter.updateProgress()
        }
    }
    
    @objc func dragReport(pan:UIPanGestureRecognizer) {
        switch pan.state {
        case UIGestureRecognizer.State.began:
            self.reportY = self.layoutReportTop.constant
            break
        case UIGestureRecognizer.State.possible, UIGestureRecognizer.State.changed:
            var newY:CGFloat = self.reportY + pan.translation(in:self.view).y
            if newY < -Constants.reportHeight {
                newY = -Constants.reportHeight
            }
            self.layoutReportTop.constant = newY
            break
        case UIGestureRecognizer.State.cancelled, UIGestureRecognizer.State.ended, UIGestureRecognizer.State.failed:
            if self.layoutReportTop.constant < -(Constants.reportHeight - Constants.reportThreshold) {
                self.showReport()
            } else {
                self.hideReport()
            }
            break
        }
    }
    
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        self.configureViewModel()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = self.presenter.interactor.board.text
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
        self.scroll = scroll
        self.view.addSubview(scroll)
        
        let border:UIView = UIView()
        border.isUserInteractionEnabled = false
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor.white
        border.layer.shadowRadius = 2.0
        border.layer.shadowOffset = CGSize(width:0.0, height:-0.5)
        border.layer.shadowColor = UIColor.black.cgColor
        border.layer.shadowOpacity = 0.3
        self.border = border
        self.view.addSubview(border)
        
        let report:UIView = UIView()
        report.translatesAutoresizingMaskIntoConstraints = false
        report.backgroundColor = UIColor.white
        report.clipsToBounds = true
        report.addGestureRecognizer(UIPanGestureRecognizer(target:self, action:#selector(self.dragReport(pan:))))
        self.report = report
        self.view.addSubview(report)
        
        let handle:UIView = UIView()
        handle.isUserInteractionEnabled = false
        handle.translatesAutoresizingMaskIntoConstraints = false
        handle.clipsToBounds = true
        handle.backgroundColor = UIColor(white:0.0, alpha:0.06)
        handle.layer.cornerRadius = Constants.handleHeight / 2.0
        self.handle = handle
        self.report.addSubview(handle)
        
        let progress:UIProgressView = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isUserInteractionEnabled = false
        progress.progressTintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        progress.trackTintColor = UIColor(white:0.95, alpha:1.0)
        self.progress = progress
        self.report.addSubview(progress)
        
        let content:UIView = UIView()
        content.clipsToBounds = false
        self.content = content
        self.scroll.addSubview(content)
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.action, target:self.presenter,
                            action:#selector(self.presenter.share)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetEdit.pdf"), style:UIBarButtonItem.Style.plain, target:self.presenter,
                            action:#selector(self.presenter.edit))]
    }
    
    private func layoutOutlets() {
        self.scroll.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.scroll.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        
        self.report.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.report.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        self.report.heightAnchor.constraint(equalToConstant:Constants.reportHeight).isActive = true
        self.layoutReportTop = self.report.topAnchor.constraint(equalTo:self.view.bottomAnchor,
                                                                constant:Constants.reportTop)
        self.layoutReportTop.isActive = true

        self.handle.topAnchor.constraint(equalTo:self.report.topAnchor, constant:Constants.handleTop).isActive = true
        self.handle.centerXAnchor.constraint(equalTo:self.report.centerXAnchor).isActive = true
        self.handle.widthAnchor.constraint(equalToConstant:Constants.handleWidth).isActive = true
        self.handle.heightAnchor.constraint(equalToConstant:Constants.handleHeight).isActive = true
        
        self.border.topAnchor.constraint(equalTo:self.report.topAnchor).isActive = true
        self.border.leftAnchor.constraint(equalTo:self.report.leftAnchor).isActive = true
        self.border.rightAnchor.constraint(equalTo:self.report.rightAnchor).isActive = true
        self.border.heightAnchor.constraint(equalToConstant:Constants.border).isActive = true
        
        self.progress.widthAnchor.constraint(equalToConstant:Constants.progressWidth).isActive = true
        self.progress.centerXAnchor.constraint(equalTo:self.report.centerXAnchor).isActive = true
        self.progress.topAnchor.constraint(equalTo:self.handle.bottomAnchor,
                                           constant:Constants.progressTop).isActive = true
        
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
            self?.drawer.draw()
            self?.layouter.layout()
        }
        
        self.presenter.viewModels.observe { [weak self] (viewModel:BoardProgressViewModel) in
            self?.progress.setProgress(viewModel.progress, animated:true)
        }
    }
    
    private func animate() {
        UIView.animate(withDuration:Constants.animation) { [weak self] in
            self?.content?.layoutIfNeeded()
        }
    }
    
    private func hideReport() {
        self.layoutReportTop.constant = Constants.reportTop
        UIView.animate(withDuration:Constants.animation) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func showReport() {
        self.layoutReportTop.constant = -Constants.reportHeight
        UIView.animate(withDuration:Constants.animation) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

private struct Constants {
    static let animation:TimeInterval = 0.3
    static let reportHeight:CGFloat = 250.0
    static let reportTop:CGFloat = -50.0
    static let reportThreshold:CGFloat = 150.0
    static let border:CGFloat = 1.0
    static let progressTop:CGFloat = 22.0
    static let progressWidth:CGFloat = 150.0
    static let handleWidth:CGFloat = 28.0
    static let handleHeight:CGFloat = 3.0
    static let handleTop:CGFloat = 10.0
}
