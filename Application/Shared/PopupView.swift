import UIKit
import CleanArchitecture

class PopupView<P:Presenter>:View<P> {
    weak var blur:UIVisualEffectView!
    weak var back:UIControl!
    weak var base:UIView!
    
    override init(presenter:P) {
        super.init(presenter:presenter)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init() { fatalError() }
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        makeOutlets()
        layoutOutlets()
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        blur.alpha = 0.85
        view.addSubview(blur)
        self.blur = blur
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(back)
        self.back = back
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .white
        base.layer.cornerRadius = 5
        base.clipsToBounds = true
        view.addSubview(base)
        self.base = base
    }
    
    func layoutOutlets() {
        blur.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
    }
}
