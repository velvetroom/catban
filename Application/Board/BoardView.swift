import UIKit
import CleanArchitecture

class BoardView:View<BoardPresenter> {
    weak var scroll:UIScrollView!
    weak var content:UIView!
    weak var report:UIView!
    weak var blur:UIVisualEffectView!
    weak var progressTrack:UIView!
    weak var progressBar:UIView!
    weak var progressTitle:UILabel!
    weak var layoutBarWidth:NSLayoutConstraint!
    let drawer:BoardDrawer
    let layouter:BoardLayouter
    
    required init() {
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
        
        let report:UIView = UIView()
        report.translatesAutoresizingMaskIntoConstraints = false
        report.layer.borderWidth = Constants.reportBorder
        report.layer.borderColor = UIColor(white:0.0, alpha:0.1).cgColor
        report.clipsToBounds = true
        self.report = report
        self.view.addSubview(report)
        
        let blur:UIVisualEffectView = UIVisualEffectView(effect:UIBlurEffect(style:UIBlurEffect.Style.light))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        blur.alpha = Constants.blurAlpha
        self.blur = blur
        self.report.addSubview(blur)
        
        let progressTrack:UIView = UIView()
        progressTrack.isUserInteractionEnabled = false
        progressTrack.translatesAutoresizingMaskIntoConstraints = false
        progressTrack.backgroundColor = UIColor(white:0.0, alpha:0.1)
        self.progressTrack = progressTrack
        self.report.addSubview(progressTrack)
        
        let progressBar:UIView = UIView()
        progressBar.isUserInteractionEnabled = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        self.progressBar = progressBar
        self.progressTrack.addSubview(progressBar)
        
        let progressTitle:UILabel = UILabel()
        progressTitle.isUserInteractionEnabled = false
        progressTitle.translatesAutoresizingMaskIntoConstraints = false
        progressTitle.font = UIFont.systemFont(ofSize:Constants.reportFont, weight:UIFont.Weight.bold)
        progressTitle.textColor = UIColor(white:0.0, alpha:0.4)
        progressTitle.text = NSLocalizedString("BoardView.progressTitle", comment:String())
        self.progressTitle = progressTitle
        self.report.addSubview(progressTitle)
        
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
        
        self.report.topAnchor.constraint(equalTo:self.view.bottomAnchor,
                                         constant:Constants.reportMinTop).isActive = true
        self.report.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.report.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        self.report.heightAnchor.constraint(equalToConstant:Constants.reportHeight).isActive = true
        
        self.blur.topAnchor.constraint(equalTo:self.report.topAnchor).isActive = true
        self.blur.bottomAnchor.constraint(equalTo:self.report.bottomAnchor).isActive = true
        self.blur.leftAnchor.constraint(equalTo:self.report.leftAnchor).isActive = true
        self.blur.rightAnchor.constraint(equalTo:self.report.rightAnchor).isActive = true
        
        self.progressTrack.leftAnchor.constraint(equalTo:self.report.leftAnchor).isActive = true
        self.progressTrack.rightAnchor.constraint(equalTo:self.report.rightAnchor).isActive = true
        self.progressTrack.topAnchor.constraint(equalTo:self.report.topAnchor, constant:
            -(Constants.reportMinTop + Constants.progressHeight)).isActive = true
        self.progressTrack.heightAnchor.constraint(equalToConstant:Constants.progressHeight).isActive = true
        
        self.progressBar.leftAnchor.constraint(equalTo:self.progressTrack.leftAnchor).isActive = true
        self.progressBar.topAnchor.constraint(equalTo:self.progressTrack.topAnchor).isActive = true
        self.progressBar.bottomAnchor.constraint(equalTo:self.progressTrack.bottomAnchor).isActive = true
        self.layoutBarWidth = self.progressBar.widthAnchor.constraint(equalToConstant:0.0)
        self.layoutBarWidth.isActive = true
        
        self.progressTitle.topAnchor.constraint(equalTo:self.report.topAnchor,
                                                constant:Constants.reportMargin).isActive = true
        self.progressTitle.leftAnchor.constraint(equalTo:self.report.leftAnchor,
                                                constant:Constants.reportMargin).isActive = true
        
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
            guard let width:CGFloat = self?.progressTrack.bounds.width else { return }
            self?.layoutBarWidth?.constant = viewModel.progress * width
            UIView.animate(withDuration:Constants.animation) { [weak self] in
                self?.progressTrack.layoutIfNeeded()
            }
        }
    }
    
    private func animate() {
        UIView.animate(withDuration:Constants.animation) { [weak self] in
            self?.content?.layoutIfNeeded()
        }
    }
}

private struct Constants {
    static let animation:TimeInterval = 0.3
    static let reportHeight:CGFloat = 250.0
    static let reportMinTop:CGFloat = -50.0
    static let reportBorder:CGFloat = 1.0
    static let blurAlpha:CGFloat = 0.95
    static let progressHeight:CGFloat = 10.0
    static let reportFont:CGFloat = 12.0
    static let reportMargin:CGFloat = 12.0
}
