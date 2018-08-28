import UIKit

class ShareView:PopupView<SharePresenter> {
    weak var image:UIImageView!
    weak var label:UILabel!
    weak var done:UIButton!
    weak var send:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    override func makeOutlets() {
        super.makeOutlets()
        back.addTarget(presenter, action:#selector(presenter.done), for:.touchUpInside)
        
        let image = UIImageView()
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        base.addSubview(image)
        self.image = image
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize:14, weight:.light)
        label.text = NSLocalizedString("ShareView.label", comment:String())
        base.addSubview(label)
        self.label = label
        
        let done = UIButton()
        done.translatesAutoresizingMaskIntoConstraints = false
        done.addTarget(presenter, action:#selector(presenter.done), for:.touchUpInside)
        done.setTitleColor(UIColor(white:0, alpha:0.4), for:.normal)
        done.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        done.setTitle(NSLocalizedString("ShareView.done", comment:String()), for:[])
        done.titleLabel!.font = UIFont.systemFont(ofSize:14, weight:.bold)
        base.addSubview(done)
        self.done = done
        
        let send = UIButton()
        send.translatesAutoresizingMaskIntoConstraints = false
        send.addTarget(self, action:#selector(sendImage), for:.touchUpInside)
        send.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        send.setTitleColor(.white, for:.normal)
        send.setTitleColor(UIColor(white:1, alpha:0.2), for:.highlighted)
        send.setTitle(NSLocalizedString("ShareView.send", comment:String()), for:[])
        send.titleLabel!.font = UIFont.systemFont(ofSize:14, weight:.bold)
        send.layer.cornerRadius = 6
        base.addSubview(send)
        self.send = send
    }
    
    override func layoutOutlets() {
        super.layoutOutlets()
        base.widthAnchor.constraint(equalToConstant:320).isActive = true
        base.heightAnchor.constraint(equalToConstant:480).isActive = true
        base.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        base.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo:image.bottomAnchor, constant:20).isActive = true
        label.leftAnchor.constraint(equalTo:base.leftAnchor, constant:20).isActive = true
        label.rightAnchor.constraint(equalTo:base.rightAnchor, constant:-20).isActive = true
        
        done.leftAnchor.constraint(equalTo:label.leftAnchor).isActive = true
        done.rightAnchor.constraint(equalTo:label.rightAnchor).isActive = true
        done.topAnchor.constraint(equalTo:send.bottomAnchor).isActive = true
        done.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        send.leftAnchor.constraint(equalTo:base.leftAnchor, constant:14).isActive = true
        send.rightAnchor.constraint(equalTo:base.rightAnchor, constant:-14).isActive = true
        send.topAnchor.constraint(equalTo:label.bottomAnchor, constant:20).isActive = true
        send.heightAnchor.constraint(equalToConstant:38).isActive = true
        
        image.topAnchor.constraint(equalTo:base.topAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant:320).isActive = true
    }
    
    private func configureViewModel() {
        presenter.viewModels.observe { [weak self] (viewModel:ShareViewModel) in self?.image.image = viewModel.image }
    }
    
    @objc private func sendImage() {
        presenter.send(image:image.image!)
    }
}
