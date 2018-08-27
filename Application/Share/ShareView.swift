import UIKit
import CleanArchitecture

class ShareView:View<SharePresenter> {
    weak var blur:UIVisualEffectView!
    weak var back:UIControl!
    weak var base:UIView!
    weak var image:UIImageView!
    weak var label:UILabel!
    weak var done:UIButton!
    weak var send:UIButton!
    
    override func viewDidLoad() {
        makeOutlets()
        layoutOutlets()
        super.viewDidLoad()
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .clear
        configureViewModel()
    }
    
    private func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        view.addSubview(blur)
        self.blur = blur
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(presenter, action:#selector(presenter.done), for:.touchUpInside)
        view.addSubview(back)
        self.back = back
        
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = UIColor(white:1, alpha:0.9)
        base.layer.cornerRadius = 6
        base.clipsToBounds = true
        view.addSubview(base)
        self.base = base
        
        let image = UIImageView()
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        view.addSubview(image)
        self.image = image
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize:16, weight:.regular)
        label.text = NSLocalizedString("ShareView.label", comment:String())
        view.addSubview(label)
        self.label = label
        
        let done = UIButton()
        done.translatesAutoresizingMaskIntoConstraints = false
        done.addTarget(presenter, action:#selector(presenter.done), for:.touchUpInside)
        done.setTitleColor(.black, for:.normal)
        done.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        done.setTitle(NSLocalizedString("ShareView.done", comment:String()), for:[])
        done.titleLabel!.font = UIFont.systemFont(ofSize:16, weight:.bold)
        view.addSubview(done)
        self.done = done
        
        let send = UIButton()
        send.translatesAutoresizingMaskIntoConstraints = false
        send.addTarget(self, action:#selector(sendImage), for:.touchUpInside)
        send.setTitleColor(#colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1), for:.normal)
        send.setTitleColor(#colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1).withAlphaComponent(0.2), for:.highlighted)
        send.setTitle(NSLocalizedString("ShareView.send", comment:String()), for:[])
        send.titleLabel!.font = UIFont.systemFont(ofSize:16, weight:.bold)
        view.addSubview(send)
        self.send = send
    }
    
    private func layoutOutlets() {
        blur.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        base.widthAnchor.constraint(equalToConstant:300).isActive = true
        base.heightAnchor.constraint(equalToConstant:420).isActive = true
        base.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        base.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo:base.topAnchor, constant:20).isActive = true
        label.leftAnchor.constraint(equalTo:base.leftAnchor, constant:20).isActive = true
        label.rightAnchor.constraint(equalTo:base.rightAnchor, constant:-20).isActive = true
        
        done.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        done.rightAnchor.constraint(equalTo:base.centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:base.bottomAnchor).isActive = true
        done.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        send.leftAnchor.constraint(equalTo:base.centerXAnchor).isActive = true
        send.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        send.bottomAnchor.constraint(equalTo:base.bottomAnchor).isActive = true
        send.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        image.topAnchor.constraint(equalTo:label.bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:send.topAnchor).isActive = true
    }
    
    private func configureViewModel() {
        presenter.viewModels.observe { [weak self] (viewModel:ShareViewModel) in self?.image.image = viewModel.image }
    }
    
    @objc private func sendImage() {
        presenter.send(image:image.image!)
    }
}
