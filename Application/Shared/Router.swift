import UIKit

class Router:UINavigationController {
    init() {
        super.init(nibName:nil, bundle:nil)
        self.configureNavigation()
        self.setViewControllers([LibraryView()], animated:false)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        if let gesture:UIGestureRecognizer = self.interactivePopGestureRecognizer {
            self.view.removeGestureRecognizer(gesture)
        }
    }
    
    private func configureNavigation() {
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.isTranslucent = false
        self.toolbar.barTintColor = UIColor.white
        self.toolbar.tintColor = UIColor.black
        self.toolbar.isTranslucent = false
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
        }
    }
}
