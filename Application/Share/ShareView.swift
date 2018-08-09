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
        self.makeOutlets()
        self.layoutOutlets()
        super.viewDidLoad()
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.view.backgroundColor = UIColor.clear
        self.configureViewModel()
    }
    
    private func makeOutlets() {
        let blur:UIVisualEffectView = UIVisualEffectView(effect:UIBlurEffect(style:UIBlurEffect.Style.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        self.blur = blur
        self.view.addSubview(blur)
        
        let back:UIControl = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self.presenter, action:#selector(self.presenter.done), for:UIControl.Event.touchUpInside)
        self.back = back
        self.view.addSubview(back)
        
        let base:UIView = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = UIColor(white:1.0, alpha:0.6)
        base.layer.cornerRadius = Constants.radius
        base.clipsToBounds = true
        self.base = base
        self.view.addSubview(base)
        
        let image:UIImageView = UIImageView()
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = UIView.ContentMode.scaleAspectFit
        self.image = image
        self.view.addSubview(image)
        
        let label:UILabel = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.regular)
        label.text = NSLocalizedString("ShareView.label", comment:String())
        self.label = label
        self.view.addSubview(label)
        
        let done:UIButton = UIButton()
        done.translatesAutoresizingMaskIntoConstraints = false
        done.addTarget(self.presenter, action:#selector(self.presenter.done), for:UIControl.Event.touchUpInside)
        done.setTitleColor(UIColor(white:0.0, alpha:0.4), for:UIControl.State.normal)
        done.setTitleColor(UIColor(white:0.0, alpha:0.2), for:UIControl.State.highlighted)
        done.setTitle(NSLocalizedString("ShareView.done", comment:String()), for:UIControl.State())
        done.titleLabel!.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.bold)
        self.done = done
        self.view.addSubview(done)
        
        let send:UIButton = UIButton()
        send.translatesAutoresizingMaskIntoConstraints = false
        send.addTarget(self, action:#selector(self.sendImage), for:UIControl.Event.touchUpInside)
        send.setTitleColor(UIColor.black, for:UIControl.State.normal)
        send.setTitleColor(UIColor(white:0.0, alpha:0.2), for:UIControl.State.highlighted)
        send.setTitle(NSLocalizedString("ShareView.send", comment:String()), for:UIControl.State())
        send.titleLabel!.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.bold)
        self.send = send
        self.view.addSubview(send)
    }
    
    private func layoutOutlets() {
        self.blur.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        self.blur.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        self.blur.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.blur.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        
        self.back.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        self.back.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        self.back.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.back.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        
        self.base.widthAnchor.constraint(equalToConstant:Constants.width).isActive = true
        self.base.heightAnchor.constraint(equalToConstant:Constants.height).isActive = true
        self.base.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        self.base.centerYAnchor.constraint(equalTo:self.view.centerYAnchor).isActive = true
        
        self.label.topAnchor.constraint(equalTo:self.base.topAnchor, constant:Constants.margin).isActive = true
        self.label.leftAnchor.constraint(equalTo:self.base.leftAnchor, constant:Constants.margin).isActive = true
        self.label.rightAnchor.constraint(equalTo:self.base.rightAnchor, constant:-Constants.margin).isActive = true
        
        self.done.leftAnchor.constraint(equalTo:self.base.leftAnchor).isActive = true
        self.done.rightAnchor.constraint(equalTo:self.base.centerXAnchor).isActive = true
        self.done.bottomAnchor.constraint(equalTo:self.base.bottomAnchor).isActive = true
        self.done.heightAnchor.constraint(equalToConstant:Constants.buttonHeight).isActive = true
        
        self.send.leftAnchor.constraint(equalTo:self.base.centerXAnchor).isActive = true
        self.send.rightAnchor.constraint(equalTo:self.base.rightAnchor).isActive = true
        self.send.bottomAnchor.constraint(equalTo:self.base.bottomAnchor).isActive = true
        self.send.heightAnchor.constraint(equalToConstant:Constants.buttonHeight).isActive = true
        
        self.image.topAnchor.constraint(equalTo:self.label.bottomAnchor).isActive = true
        self.image.leftAnchor.constraint(equalTo:self.base.leftAnchor).isActive = true
        self.image.rightAnchor.constraint(equalTo:self.base.rightAnchor).isActive = true
        self.image.bottomAnchor.constraint(equalTo:self.send.topAnchor).isActive = true
    }
    
    private func configureViewModel() {
        self.presenter.viewModels.observe { [weak self] (viewModel:ShareViewModel) in
            self?.image.image = viewModel.image
        }
    }
    
    @objc private func sendImage() {
        guard let image:UIImage = self.image.image else { return }
        self.presenter.send(image:image)
    }
}

private struct Constants {
    static let radius:CGFloat = 6.0
    static let width:CGFloat = 300.0
    static let height:CGFloat = 440.0
    static let font:CGFloat = 16.0
    static let margin:CGFloat = 20.0
    static let buttonHeight:CGFloat = 50.0
}
