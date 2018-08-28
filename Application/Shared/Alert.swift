import UIKit

class Alert:UIViewController {
    var image:UIImage? { didSet { icon?.image = image } }
    override var title:String? { didSet { label?.text = title } }
    private weak var timer:Timer?
    private weak var base:UIView!
    private weak var icon:UIImageView!
    private weak var label:UILabel!
    private static let top:CGFloat = 20
    private static let horizontal:CGFloat = 12
    private static let margin:CGFloat = 5
    private static let height:CGFloat = 60
    
    init() {
        super.init(nibName:nil, bundle:nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .clear
        Application.router.present(self, animated:true)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(
            timeInterval:4, target:self, selector:#selector(timeout), userInfo:nil, repeats:false)
        makeOutlets()
        layoutOutlets()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func makeOutlets() {
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.backgroundColor = UIColor(white:0.96, alpha:1)
        base.translatesAutoresizingMaskIntoConstraints = false
        base.layer.cornerRadius = 4
        base.clipsToBounds = true
        base.layer.borderColor = UIColor(white:0.9, alpha:1).cgColor
        base.layer.borderWidth = 1
        view.addSubview(base)
        self.base = base
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.systemFont(ofSize:14, weight:.medium)
        label.textColor = .black
        label.numberOfLines = 0
        view.addSubview(label)
        self.label = label
        
        let icon = UIImageView()
        icon.isUserInteractionEnabled = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.contentMode = .center
        icon.image = image
        view.addSubview(icon)
        self.icon = icon
    }
    
    private func layoutOutlets() {
        base.leftAnchor.constraint(equalTo:view.leftAnchor, constant:Alert.margin).isActive = true
        base.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-Alert.margin).isActive = true
        base.heightAnchor.constraint(equalToConstant:Alert.height).isActive = true
        
        label.topAnchor.constraint(equalTo:base.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:base.leftAnchor, constant:Alert.horizontal).isActive = true
        label.rightAnchor.constraint(equalTo:icon.leftAnchor, constant:-Alert.horizontal).isActive = true
        label.bottomAnchor.constraint(equalTo:base.bottomAnchor).isActive = true
        
        icon.centerYAnchor.constraint(equalTo:base.centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant:Alert.height).isActive = true
        icon.heightAnchor.constraint(equalToConstant:Alert.height).isActive = true
        icon.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            base.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:Alert.top).isActive = true
        } else {
            base.topAnchor.constraint(equalTo:view.topAnchor, constant:Alert.top).isActive = true
        }
    }
    
    @objc private func timeout() {
        Application.router.dismiss(animated:true)
    }
}
