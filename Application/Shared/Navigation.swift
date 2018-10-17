import UIKit

class Navigation:UINavigationController {
    override var preferredStatusBarStyle:UIStatusBarStyle { return Application.interface.status }
    
    func launchDefault() { setViewControllers([LibraryView()], animated:false) }
    func quick(board:String) { pushViewController(library().board(identifier:board), animated:true) }
    func quickAdd() { library().newBoard() }
    func quickScan() { library().scan() }
    
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
    
    func configureNavigation() {
        UIApplication.shared.windows.first!.backgroundColor = Application.interface.background
        navigationBar.barTintColor = Application.interface.background
        navigationBar.tintColor = Application.interface.tint
        navigationBar.setValue(true, forKey:"hidesShadow")
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [.foregroundColor:Application.interface.tint]
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationBar.largeTitleTextAttributes = [.foregroundColor:Application.interface.tint]
        }
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
    
    private func library() -> LibraryPresenter {
        dismiss(animated:false)
        let view = viewControllers.first as! LibraryView
        popToViewController(view, animated:false)
        return view.presenter
    }
}
