import UIKit
import CleanArchitecture

class InfoView<I:Interactor>:View<InfoPresenter<I>> {
    weak var blur:UIVisualEffectView!
    weak var back:UIControl!
    weak var base:UIView!
    weak var dismiss:UIButton!
    weak var text:UITextView!
    
    override func viewDidLoad() {
        makeOutlets()
        layoutOutlets()
        configureViewModel()
        super.viewDidLoad()
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .clear
    }
    
    private func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        view.addSubview(blur)
        self.blur = blur
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(presenter, action:#selector(presenter.dismiss), for:.touchUpInside)
        view.addSubview(back)
        self.back = back
        
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .white
        base.layer.cornerRadius = 4
        base.clipsToBounds = true
        view.addSubview(base)
        self.base = base
        
        let text = UITextView()
        text.clipsToBounds = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.textColor = .black
        text.tintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        text.alwaysBounceVertical = true
        text.showsHorizontalScrollIndicator = false
        text.isEditable = false
        text.contentInset = .zero
        text.textContainerInset = UIEdgeInsets(top:30, left:12, bottom:30, right:12)
        view.addSubview(text)
        self.text = text
        
        let dismiss = UIButton()
        dismiss.translatesAutoresizingMaskIntoConstraints = false
        dismiss.addTarget(presenter, action:#selector(presenter.dismiss), for:.touchUpInside)
        dismiss.setTitleColor(.white, for:.normal)
        dismiss.setTitleColor(UIColor(white:1, alpha:0.2), for:.highlighted)
        dismiss.setTitle(NSLocalizedString("InfoView.dismiss", comment:String()), for:[])
        dismiss.titleLabel!.font = UIFont.systemFont(ofSize:14, weight:.bold)
        view.addSubview(dismiss)
        self.dismiss = dismiss
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
        
        base.leftAnchor.constraint(equalTo:view.leftAnchor, constant:15).isActive = true
        base.rightAnchor.constraint(equalTo:view.rightAnchor,constant:-15).isActive = true
        base.topAnchor.constraint(equalTo:view.topAnchor, constant:45).isActive = true
        base.bottomAnchor.constraint(equalTo:dismiss.topAnchor).isActive = true
        
        dismiss.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        dismiss.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-15).isActive = true
        dismiss.heightAnchor.constraint(equalToConstant:50).isActive = true
        dismiss.widthAnchor.constraint(equalToConstant:150).isActive = true
        
        text.topAnchor.constraint(equalTo:base.topAnchor).isActive = true
        text.bottomAnchor.constraint(equalTo:base.bottomAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
    }
    
    private func configureViewModel() {
        presenter.viewModels.observe { [weak self] (viewModel:InfoViewModel) in
            self?.text.attributedText = viewModel.text
        }
    }
}
