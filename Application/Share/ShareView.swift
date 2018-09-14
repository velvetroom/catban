import UIKit

class ShareView:PopupView<SharePresenter> {
    private weak var image:UIImageView!
    
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
        
        let done = UIButton()
        done.translatesAutoresizingMaskIntoConstraints = false
        done.addTarget(presenter, action:#selector(presenter.done), for:.touchUpInside)
        done.setTitleColor(UIColor(white:0, alpha:0.4), for:.normal)
        done.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        done.setTitle(NSLocalizedString("ShareView.done", comment:String()), for:[])
        done.titleLabel!.font = .systemFont(ofSize:14, weight:.bold)
        base.addSubview(done)
        
        let send = UIButton()
        send.translatesAutoresizingMaskIntoConstraints = false
        send.addTarget(self, action:#selector(sendImage), for:.touchUpInside)
        send.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        send.setTitleColor(.white, for:.normal)
        send.setTitleColor(UIColor(white:1, alpha:0.2), for:.highlighted)
        send.setTitle(NSLocalizedString("ShareView.send", comment:String()), for:[])
        send.titleLabel!.font = .systemFont(ofSize:14, weight:.bold)
        send.layer.cornerRadius = 6
        base.addSubview(send)
        
        base.widthAnchor.constraint(equalToConstant:320).isActive = true
        base.heightAnchor.constraint(equalToConstant:440).isActive = true
        base.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        base.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        done.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        done.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        done.topAnchor.constraint(equalTo:send.bottomAnchor).isActive = true
        done.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        send.leftAnchor.constraint(equalTo:base.leftAnchor, constant:14).isActive = true
        send.rightAnchor.constraint(equalTo:base.rightAnchor, constant:-14).isActive = true
        send.topAnchor.constraint(equalTo:image.bottomAnchor, constant:10).isActive = true
        send.heightAnchor.constraint(equalToConstant:48).isActive = true
        
        image.topAnchor.constraint(equalTo:base.topAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant:320).isActive = true
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (image:UIImage) in self?.image.image = image }
    }
    
    @objc private func sendImage() {
        presenter.send(image:image.image!)
    }
}
