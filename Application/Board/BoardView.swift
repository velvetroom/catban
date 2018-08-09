import UIKit
import CleanArchitecture

class BoardView:View<BoardPresenter> {
    weak var scroll:UIScrollView!
    weak var content:UIView!
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
        let view:BoardItemView = pan.view as! BoardItemView
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
        scroll.canCancelContentTouches = false
        self.scroll = scroll
        self.view.addSubview(scroll)
        
        let content:UIView = UIView()
        content.clipsToBounds = false
        self.content = content
        self.scroll.addSubview(content)
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.action, target:self.presenter,
                            action:#selector(self.presenter.share)),
            UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.edit, target:self.presenter,
                            action:#selector(self.presenter.edit))]
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
            self?.drawer.draw()
            self?.layouter.layout()
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
}
