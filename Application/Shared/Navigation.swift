import UIKit

class Navigation:UINavigationController {
    func launchDefault() {
        setViewControllers([LibraryView()], animated:false)
    }
    
    func launch(board:String) {
        let library = LibraryView()
        library.presenter.interactor.identifier = board
        library.presenter.interactor.strategy = LibraryInteractor.selectBoard
        setViewControllers([library], animated:false)
    }
    
    func launchAdd() {
        let library = LibraryView()
        library.presenter.interactor.strategy = LibraryInteractor.newBoard
        setViewControllers([library], animated:false)
    }
    
    func launchScan() {
        let library = LibraryView()
        library.presenter.interactor.strategy = LibraryInteractor.scan
        setViewControllers([library], animated:false)
    }
    
    func quick(board:String) {
        library().presenter.interactor.select(identifier:board)
    }
    
    func quickAdd() {
        library().presenter.interactor.newBoard()
    }
    
    func quickScan() {
        library().presenter.interactor.scan()
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
