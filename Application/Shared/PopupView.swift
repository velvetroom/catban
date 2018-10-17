import CleanArchitecture

class PopupView<P:Presenter>:View<P> {
    private(set) weak var back:UIControl!
    private(set) weak var base:UIView!
    
    override init(presenter:P) {
        super.init(presenter:presenter)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init() { fatalError() }
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        makeOutlets()
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        view.addSubview(blur)
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(back)
        self.back = back
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = Application.interface.over
        base.layer.cornerRadius = 8
        base.clipsToBounds = true
        view.addSubview(base)
        self.base = base
        
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
