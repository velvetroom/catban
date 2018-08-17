import UIKit
import CleanArchitecture

class InfoView<I:InfoInteractor>:View<InfoPresenter<I>> {
    weak var blur:UIVisualEffectView!
    weak var back:UIControl!
    weak var base:UIView!
    weak var dismiss:UIButton!
    weak var text:UITextView!
    
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        self.configureViewModel()
        super.viewDidLoad()
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.view.backgroundColor = UIColor.clear
    }
    
    private func makeOutlets() {
        let blur:UIVisualEffectView = UIVisualEffectView(effect:UIBlurEffect(style:UIBlurEffect.Style.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        self.blur = blur
        self.view.addSubview(blur)
        
        let back:UIControl = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self.presenter, action:#selector(self.presenter.dismiss), for:UIControl.Event.touchUpInside)
        self.back = back
        self.view.addSubview(back)
        
        let base:UIView = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = UIColor.white
        base.layer.cornerRadius = Constants.radius
        base.clipsToBounds = true
        self.base = base
        self.view.addSubview(base)
        
        let text:UITextView = UITextView()
        text.clipsToBounds = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.clear
        text.textColor = UIColor.black
        text.tintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        text.alwaysBounceVertical = true
        text.showsHorizontalScrollIndicator = false
        text.isEditable = false
        text.contentInset = UIEdgeInsets.zero
        text.textContainerInset = UIEdgeInsets(top:Constants.insets, left:Constants.insets, bottom:Constants.insets,
                                               right:Constants.insets)
        self.text = text
        self.view.addSubview(text)
        
        let dismiss:UIButton = UIButton()
        dismiss.translatesAutoresizingMaskIntoConstraints = false
        dismiss.addTarget(self.presenter, action:#selector(self.presenter.dismiss), for:UIControl.Event.touchUpInside)
        dismiss.setTitleColor(UIColor.white, for:UIControl.State.normal)
        dismiss.setTitleColor(UIColor(white:1.0, alpha:0.2), for:UIControl.State.highlighted)
        dismiss.setTitle(NSLocalizedString("InfoView.dismiss", comment:String()), for:UIControl.State())
        dismiss.titleLabel!.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.bold)
        self.dismiss = dismiss
        self.view.addSubview(dismiss)
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
        
        self.base.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant:Constants.margin).isActive = true
        self.base.rightAnchor.constraint(equalTo:self.view.rightAnchor,constant:-Constants.margin).isActive = true
        self.base.topAnchor.constraint(equalTo:self.view.topAnchor, constant:Constants.top).isActive = true
        self.base.bottomAnchor.constraint(equalTo:self.dismiss.topAnchor).isActive = true
        
        self.dismiss.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        self.dismiss.bottomAnchor.constraint(equalTo:self.view.bottomAnchor, constant:-Constants.margin).isActive = true
        self.dismiss.heightAnchor.constraint(equalToConstant:Constants.buttonHeight).isActive = true
        self.dismiss.widthAnchor.constraint(equalToConstant:Constants.buttonWidth).isActive = true
        
        self.text.topAnchor.constraint(equalTo:self.base.topAnchor, constant:Constants.textMargin).isActive = true
        self.text.bottomAnchor.constraint(equalTo:self.base.bottomAnchor,
                                          constant:-Constants.textMargin).isActive = true
        self.text.leftAnchor.constraint(equalTo:self.base.leftAnchor, constant:Constants.textMargin).isActive = true
        self.text.rightAnchor.constraint(equalTo:self.base.rightAnchor, constant:-Constants.textMargin).isActive = true
    }
    
    private func configureViewModel() {
        self.presenter.viewModels.observe { [weak self] (viewModel:InfoViewModel) in
            self?.text.attributedText = viewModel.text
        }
    }
}

private struct Constants {
    static let radius:CGFloat = 4.0
    static let top:CGFloat = 45.0
    static let margin:CGFloat = 15.0
    static let font:CGFloat = 14.0
    static let buttonHeight:CGFloat = 50.0
    static let buttonWidth:CGFloat = 150.0
    static let textMargin:CGFloat = 4.0
    static let insets:CGFloat = 12.0
}
