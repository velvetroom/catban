import UIKit

class Alert:UIViewController {
    var image:UIImage? { didSet { icon?.image = image } }
    override var title:String? { didSet { label?.text = title } }
    private weak var timer:Timer?
    private weak var icon:UIImageView!
    private weak var label:UILabel!
    override var preferredStatusBarStyle:UIStatusBarStyle { return Application.interface.status }
    
    init() {
        super.init(nibName:nil, bundle:nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
        Application.navigation.present(self, animated:false)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(
            timeInterval:5, target:self, selector:#selector(timeout), userInfo:nil, repeats:false)
        makeOutlets()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func makeOutlets() {
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.backgroundColor = Application.interface.over
        base.translatesAutoresizingMaskIntoConstraints = false
        base.layer.cornerRadius = 10
        view.addSubview(base)
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = .systemFont(ofSize:14, weight:.regular)
        label.textColor = Application.interface.text
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
        
        base.leftAnchor.constraint(equalTo:view.leftAnchor, constant:8).isActive = true
        base.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-8).isActive = true
        base.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        label.topAnchor.constraint(equalTo:base.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:base.leftAnchor, constant:15).isActive = true
        label.rightAnchor.constraint(equalTo:icon.leftAnchor, constant:-15).isActive = true
        label.bottomAnchor.constraint(equalTo:base.bottomAnchor).isActive = true
        
        icon.centerYAnchor.constraint(equalTo:base.centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant:60).isActive = true
        icon.heightAnchor.constraint(equalToConstant:60).isActive = true
        icon.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            base.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:10).isActive = true
        } else {
            base.topAnchor.constraint(equalTo:view.topAnchor, constant:10).isActive = true
        }
    }

    @objc private func timeout() {
        Application.navigation.dismiss(animated:false)
    }
}
