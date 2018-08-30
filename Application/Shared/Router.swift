import UIKit

class Router:UINavigationController {
    
    init() {
        super.init(nibName:nil, bundle:nil)
        configureNavigation()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func regular() {
        setViewControllers([LibraryView()], animated:false)
    }
    
    func quick(board:String) {
        dismiss(animated:false)
        let library = LibraryView()
        library.presenter.interactor.state = LibraryQuick(board:board)
        setViewControllers([library], animated:false)
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
        navigationBar.isTranslucent = false
        toolbar.barTintColor = .white
        toolbar.tintColor = .black
        toolbar.isTranslucent = false
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }
    }
}
