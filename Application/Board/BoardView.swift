import UIKit
import CleanArchitecture

class BoardView:View<BoardPresenter> {
    weak var scroll:UIScrollView!
    weak var touch:BoardTouchView!
    private let organiser:BoardOrganiser
    
    required init() {
        self.organiser = BoardOrganiser()
        super.init()
        self.organiser.view = self
    }
    
    deinit {
        print("de init board")
    }
    
    required init?(coder:NSCoder) { return nil }
    
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
        
        let touch:BoardTouchView = BoardTouchView()
        self.touch = touch
        self.scroll.addSubview(touch)
        
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
            self?.organiser.refresh()
        }
    }
}
