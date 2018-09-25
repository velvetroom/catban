import UIKit

class Navigation:UINavigationController {
    func launchDefault() { setViewControllers([LibraryView()], animated:false) }
    func quick(board:String) { library().presenter.select(identifier:board) }
    func quickAdd() { library().presenter.newBoard() }
    func quickScan() { library().presenter.scan() }
    
    func launch(board:String) {
        let library = LibraryView()
        library.presenter.identifier = board
        library.presenter.strategy = LibraryPresenter.selectBoard
        setViewControllers([library], animated:false)
    }
    
    func launchAdd() {
        let library = LibraryView()
        library.presenter.strategy = LibraryPresenter.newBoard
        setViewControllers([library], animated:false)
    }
    
    func launchScan() {
        let library = LibraryView()
        library.presenter.strategy = LibraryPresenter.scan
        setViewControllers([library], animated:false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        if let gesture = interactivePopGestureRecognizer {
            view.removeGestureRecognizer(gesture)
        }
    }
    
    private func configureNavigation() {
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .black
        navigationBar.setValue(true, forKey:"hidesShadow")
        navigationBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    private func library() -> LibraryView {
        dismiss(animated:false)
        let view = viewControllers.first as! LibraryView
        popToViewController(view, animated:false)
        return view
    }
}
