import UIKit
import CleanArchitecture

class SettingsView:View<SettingsPresenter> {
    weak var scroll:UIScrollView!
    weak var content:UIView!
    
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        self.configureViewModel()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("SettingsView.title", comment:"")
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
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
        
        let content:UIView = UIView()
        content.clipsToBounds = false
        self.content = content
        self.scroll.addSubview(content)
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
        
    }
}
