import UIKit
import CleanArchitecture

class DeleteView:View<DeletePresenter> {
    weak var blur:UIVisualEffectView!
    weak var back:UIControl!
    weak var base:UIView!
    weak var label:UILabel!
    weak var cancel:UIButton!
    weak var delete:UIButton!
    weak var border:UIView!

    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
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
        back.addTarget(self.presenter, action:#selector(self.presenter.cancel), for:UIControl.Event.touchUpInside)
        self.back = back
        self.view.addSubview(back)
        
        let base:UIView = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = UIColor(white:1.0, alpha:0.9)
        base.layer.cornerRadius = Constants.radius
        base.clipsToBounds = true
        self.base = base
        self.view.addSubview(base)
        
        let label:UILabel = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize:Constants.label, weight:UIFont.Weight.regular)
        label.text = self.presenter.strategy.title
        self.label = label
        self.view.addSubview(label)
        
        let cancel:UIButton = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self.presenter, action:#selector(self.presenter.cancel), for:UIControl.Event.touchUpInside)
        cancel.setTitleColor(Colors.vanillaRed, for:UIControl.State.normal)
        cancel.setTitleColor(Colors.vanillaRed.withAlphaComponent(0.2), for:UIControl.State.highlighted)
        cancel.setTitle(NSLocalizedString("DeleteView.cancel", comment:String()), for:UIControl.State())
        cancel.titleLabel!.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.bold)
        self.cancel = cancel
        self.view.addSubview(cancel)
        
        let delete:UIButton = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.addTarget(self.presenter, action:#selector(self.presenter.delete), for:UIControl.Event.touchUpInside)
        delete.setTitleColor(UIColor.black, for:UIControl.State.normal)
        delete.setTitleColor(UIColor(white:0.0, alpha:0.2), for:UIControl.State.highlighted)
        delete.setTitle(NSLocalizedString("DeleteView.delete", comment:String()), for:UIControl.State())
        delete.titleLabel!.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.bold)
        self.delete = delete
        self.view.addSubview(delete)
        
        let border:UIView = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor(white:0.0, alpha:0.1)
        border.isUserInteractionEnabled = false
        self.border = border
        self.view.addSubview(border)
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
        
        self.cancel.leftAnchor.constraint(equalTo:self.base.leftAnchor).isActive = true
        self.cancel.rightAnchor.constraint(equalTo:self.base.centerXAnchor).isActive = true
        self.cancel.bottomAnchor.constraint(equalTo:self.base.bottomAnchor).isActive = true
        self.cancel.heightAnchor.constraint(equalToConstant:Constants.buttonHeight).isActive = true
        
        self.delete.leftAnchor.constraint(equalTo:self.base.centerXAnchor).isActive = true
        self.delete.rightAnchor.constraint(equalTo:self.base.rightAnchor).isActive = true
        self.delete.bottomAnchor.constraint(equalTo:self.base.bottomAnchor).isActive = true
        self.delete.heightAnchor.constraint(equalToConstant:Constants.buttonHeight).isActive = true
        
        self.border.leftAnchor.constraint(equalTo:self.base.leftAnchor).isActive = true
        self.border.rightAnchor.constraint(equalTo:self.base.rightAnchor).isActive = true
        self.border.bottomAnchor.constraint(equalTo:self.cancel.topAnchor).isActive = true
        self.border.heightAnchor.constraint(equalToConstant:Constants.border).isActive = true
    }
}

private struct Constants {
    static let border:CGFloat = 1.0
    static let radius:CGFloat = 8.0
    static let width:CGFloat = 260.0
    static let height:CGFloat = 115.0
    static let font:CGFloat = 15.0
    static let label:CGFloat = 18.0
    static let margin:CGFloat = 20.0
    static let buttonHeight:CGFloat = 45.0
}
